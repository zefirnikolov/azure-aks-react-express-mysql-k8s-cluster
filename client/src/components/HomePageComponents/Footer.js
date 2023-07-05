import React from 'react';
import './Footer.css';

const Footer = () => {
  return (
    <div className="footer">
      <p>© 2023 K8s microservice architecture deployed on Azure AKS. All Rights Reserved.</p>
      <p>
        <a href="/">Privacy Policy</a> | 
        <a href="/">Terms of Service</a>
      </p>
    </div>
  );
};

export default Footer;
