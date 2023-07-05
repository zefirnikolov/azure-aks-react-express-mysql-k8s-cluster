import React from 'react';
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';
import NavigationBar from './components/Navbar';
import Home from './components/Home';
import ProductPage from './components/ProductPage';
import { CartProvider } from './CartContext';
import CartPage from './components/CartPage';
import CheckoutPage from './components/CheckoutPage';
import NotFoundPage from './components/NotFoundPage';

function App() {
  return (
    <Router>
      <CartProvider>
      <NavigationBar />
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/category/:productName" element={<ProductPage />} />        
        <Route path="/cart" element={<CartPage />} />
        <Route path="/checkout" element={< CheckoutPage />} />
        <Route path="*" element={<NotFoundPage />} />
      </Routes>
      </CartProvider>
    </Router>
  );
}

export default App;
