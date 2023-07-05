import React, { useContext, useState } from 'react';
import { CartContext } from '../CartContext';
import { Link } from 'react-router-dom';
import "./CheckoutPage.css";

const CheckoutPage = () => {
  const { order } = useContext(CartContext);
  const [orderNumber] = useState("7000000" + Math.floor(Math.random() * (9999 - 1000 + 1) + 1000));
  const totalPrice = order.reduce((acc, cur) => acc + (cur.price * cur.quantity), 0);

  return (
    <div>
      <h2>YOUR ORDER HAS BEEN RECEIVED.</h2>
      <h3>Thank you for your purchase!</h3>
      <h3>Your order number is: #{orderNumber}:</h3>
      {order.map((product, index) => (
        <div key={index} className="cart-item">
          <h3>{product.name}</h3>
          <p>Price per 1 product: ${product.price}</p>
          <p>Quantity: {product.quantity}</p>
          <p>Total: ${(product.price * product.quantity).toFixed(2)}</p>
        </div>
      ))}
      <h2>Total Price: ${totalPrice.toFixed(2)}</h2>
      <Link to="/" className="continue-shopping">Continue Shopping</Link>
    </div>
  );
};

export default CheckoutPage;
