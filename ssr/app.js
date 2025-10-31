const path = require('path');
const fs = require('fs');
const express = require('express');
const React = require('react');
const { renderToString } = require('react-dom/server');
// Use a DOM router that exists in the browser build too, so Links have context
const { MemoryRouter } = require('react-router-dom');
const App = require('../client/src/App').default;

const app = express();
const PORT = process.env.PORT || 8080;

// Serve CRA build assets (CSS/JS)
const BUILD_DIR = path.resolve(__dirname, '../client/build');
app.use(
  express.static(BUILD_DIR, {
    index: false,
    maxAge: '1y',
    immutable: true,
  })
);

// Safe JSON embedding
function safeSerialize(obj) {
  return JSON.stringify(obj).replace(/</g, '\\u003c');
}

const DEFAULT_PRODUCTS_URL = 'http://server:5000/api/products';

// This keeps CRA’s <head> links (CSS/JS) intact so hydration is stable.
function injectIntoTemplate(html, markup, bootstrapScript) {
  const rootDivRe = /<div\s+id=["']root["'][^>]*>([\s\S]*?)<\/div>/i;

  if (rootDivRe.test(html)) {
    return html.replace(
      rootDivRe,
      `<div id="root">${markup}</div>\n${bootstrapScript}`
    );
  }

  // Fallback: if template lacks #root, append one before </body>
  return html.replace(
    /<\/body>/i,
    `<div id="root">${markup}</div>\n${bootstrapScript}\n</body>`
  );
}

/**
 * Read CRA asset-manifest.json to find main.css and inline it to avoid FOUC.
 * If manifest is missing, try to discover the CSS href from the template.
 */
function inlineCriticalCss(template) {
  try {
    const manifestPath = path.join(BUILD_DIR, 'asset-manifest.json');
    let cssHref;

    if (fs.existsSync(manifestPath)) {
      const manifest = JSON.parse(fs.readFileSync(manifestPath, 'utf8'));
      if (manifest?.files?.['main.css']) {
        cssHref = manifest.files['main.css']; // e.g. /static/css/main.XXXX.css
      } else if (Array.isArray(manifest.entrypoints)) {
        cssHref = manifest.entrypoints.find(p => p.endsWith('.css'));
      }
    }

    if (!cssHref) {
      // Last-resort: detect from <linkic/css/…
      const m = template.match(
        /<link[^"']*\/static\/css\/[^"']+\.css["'][^>]*>/i
      );
      if (m) cssHref = m[1];
    }

    if (!cssHref) return template;

    // Resolve absolute file path inside build dir (strip any leading "/")
    const cssFilePath = path.join(BUILD_DIR, cssHref.replace(/^\/+/, ''));
    if (!fs.existsSync(cssFilePath)) return template;

    const css = fs.readFileSync(cssFilePath, 'utf8');

    // Inject as the first thing before </head> to ensure styled first paint
    return template.replace(
      /<\/head>/i,
      `<style data-ssr-inline="critical">${css}</style>\n</head>`
    );
  } catch (_e) {
    return template; // Non-fatal; just skip inlining if anything goes wrong
  }
}

app.get('/healthz', (_req, res) => res.status(200).send('ok'));

app.get('*', async (req, res) => {
  // Prefer built index (has hashed CSS/JS); fall back to public for dev
  const buildIndex = path.join(BUILD_DIR, 'index.html');
  const publicIndex = path.resolve(__dirname, '../client/public/index.html');
  const templatePath = fs.existsSync(buildIndex) ? buildIndex : publicIndex;

  let template;
  try {
    template = fs.readFileSync(templatePath, 'utf8');
    // If we're using the built template, inline critical CSS to kill FOUC
    if (templatePath === buildIndex) {
      template = inlineCriticalCss(template);
    }
  } catch (e) {
    console.error('[SSR] Failed to read template:', e);
    return res.status(500).send('Template not found');
  }

  // Fetch products (best-effort)
  const productsUrl = process.env.PRODUCTS_URL || DEFAULT_PRODUCTS_URL;
  let products = [];
  try {
    const resp = await fetch(productsUrl, { cache: 'no-store' });
    if (!resp.ok) throw new Error(`${resp.status} ${resp.statusText}`);
    products = await resp.json();
  } catch (err) {
    console.error('[SSR] Failed to fetch products:', err.message);
  }

  try {
    // Make bootstrap data available during SSR
    globalThis.__BOOTSTRAP__ = products;

    const markup = renderToString(
      React.createElement(
        MemoryRouter,
        { initialEntries: [req.url] },
        React.createElement(React.StrictMode, null, React.createElement(App, null))
      )
    );

    // Serialize the same data for the client to reuse (no mismatch)
    const bootstrapScript =
      `<script>window.__BOOTSTRAP__=${safeSerialize(products)};</script>`;

    const html = injectIntoTemplate(template, markup, bootstrapScript);

    res.setHeader('Content-Type', 'text/html; charset=utf-8');
    res.status(200).send(html);
  } catch (err) {
    console.error('[SSR] Unhandled error:', err);
    res.status(500).send('Internal Server Error');
  } finally {
    // Avoid leaking data between requests in long-lived processes
    delete globalThis.__BOOTSTRAP__;
  }
});

app.listen(PORT, () => {
  console.log(`[SSR] listening on http://localhost:${PORT}`);
});
