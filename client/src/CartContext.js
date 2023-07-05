import React, { createContext, useState } from 'react';

export const CartContext = createContext();

export const CartProvider = (props) => {
  const [cart, setCart] = useState([]);
  const [order, setOrder] = useState([]);

  const addToCart = (product, quantity, imageUrl) => {
    quantity = parseInt(quantity);
    const existingProduct = cart.find(p => p.name === product.name);
    if (existingProduct) {
      setCart(cart.map(p => p.name === product.name ? {...p, quantity: p.quantity + quantity} : p));
    } else {
      setCart(prev => [...prev, {...product, quantity, imageUrl}]);
    }
  };

  const updateQuantity = (productName, quantity) => {
    setCart(prev => prev.map(product => product.name === productName ? {...product, quantity: parseInt(quantity)} : product));
  };

  const removeFromCart = (productName) => {
    setCart(prev => prev.filter(product => product.name !== productName));
  };

  const checkout = () => {
    setOrder([...cart]);
    setCart([]);
  };
  

  return (
    <CartContext.Provider value={{cart, addToCart, removeFromCart, updateQuantity, checkout, order}}>
      {props.children}
    </CartContext.Provider>
  );
};
