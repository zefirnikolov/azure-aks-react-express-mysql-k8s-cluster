import React, { useContext } from 'react';
import { CartContext } from '../CartContext';
import './CartPage.css';
import { useNavigate } from 'react-router-dom';

const CartPage = () => {
  const { cart, removeFromCart, checkout, updateQuantity } = useContext(CartContext);
  const navigate = useNavigate();

  const totalPrice = cart.reduce((acc, cur) => acc + (cur.price * cur.quantity), 0);

  const handleRemove = (productName) => {
    removeFromCart(productName);
  };

  const handleCheckout = () => {
    checkout();
    navigate('/checkout');
  };

  return (
    <div>
      <h2>Shopping cart</h2>
      <p className="cart-reminder">Reminder: You can add up to 20 of each product.</p>
      <p className="cart-reminder">For your convenience your payment will be made on site when your shipment arrive.</p>
      {cart.map((product, index) => (
        <div key={index} className="cart-item">
          <img src={product.imageUrl} alt={product.name} />
          <h3>{product.name}</h3>
          <p>Price per 1 product: ${product.price}</p>
          <p>Quantity: 
            <select value={product.quantity} onChange={(e) => updateQuantity(product.name, e.target.value)}>
              {[...Array(20)].map((_, i) => <option key={i} value={i+1}>{i+1}</option>)}
            </select>
          </p>
          <p>Total: ${(product.price * product.quantity).toFixed(2)}</p>
          <button onClick={() => handleRemove(product.name)}>Remove from cart</button>
        </div>
      ))}
      <h2>Total Price: ${totalPrice.toFixed(2)}</h2>
      {cart.length > 0 && <button className="checkout-button" onClick={handleCheckout}>Place Your Order</button>}
    </div>
  );
};

export default CartPage;
