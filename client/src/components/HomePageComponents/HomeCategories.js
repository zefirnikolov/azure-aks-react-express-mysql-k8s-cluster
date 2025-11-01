import React from 'react';
import { Link } from 'react-router-dom';
import './HomeCategories.css';

const HomeCategories = () => {
  return (
    <div className="container">
      <h1 className="title">Explore our Wide Range of Groceries</h1>
      <p>
        Demo app showing modern e‑commerce.
      </p>
      <div className="category-card">
        <div className="category-name" style={{ display: 'none' }}>Fruits-Vegetables</div>
        <div className="image-container">
          <img className="category-image" src="https://cdn.pixabay.com/photo/2015/12/16/03/34/fruit-1095331_1280.jpg" alt="Fruits-Vegetables" />
        </div>
        <div className="category-link">
          <Link to="/category/apples">Apples</Link>
          <Link to="/category/lemons">Lemons</Link>
          <Link to="/category/cherries">Cherries</Link>
          <Link to="/category/carrots">Carrots</Link>
          <Link to="/category/lettuce">Lettuce</Link>
        </div>
      </div>

      <div className="category-card">
        <div className="image-container">
          <img className="category-image" src="https://cdn.pixabay.com/photo/2014/02/28/10/38/roll-276774_1280.jpg" alt="Bread-Bakery" />
        </div>
        <div className="category-link">
        <Link to="/category/bread">Bread</Link>
          <Link to="/category/bagels">Bagels</Link>
          <Link to="/category/baguettes">Baguettes</Link>
        </div>
      </div>

      <div className="category-card">
        <div className="image-container">
          <img className="category-image" src="https://cdn.pixabay.com/photo/2015/05/25/16/14/burger-783551_1280.jpg" alt="Meat-Fish" />
        </div>
        <div className="category-link">
          <Link to="/category/chicken">Chicken</Link>
          <Link to="/category/beef">Beef</Link>
          <Link to="/category/fish">Fish</Link>
        </div>
      </div>

      <div className="category-card">
        <div className="image-container">
          <img className="category-image" src="https://images.pexels.com/photos/16177490/pexels-photo-16177490/free-photo-of-still-life-with-decorative-sweets-and-flowers-on-a-table.jpeg" alt="Sweets" />
        </div>
        <div className="category-link">
          <Link to="/category/chocolate">Chocolate</Link>
          <Link to="/category/candy">Candy</Link>
          <Link to="/category/ice-cream">Ice-Cream</Link>
        </div>
      </div>

      <div className="category-card">
        <div className="image-container">
          <img className="category-image" src="https://images.pexels.com/photos/2531188/pexels-photo-2531188.jpeg" alt="Alcohol-Alcohol-ree" />
        </div>
        <div className="category-link">
          <Link to="/category/alcoholic">Alcohol</Link>
          <Link to="/category/alcohol-free">Alcohol-free</Link>
        </div>
      </div>


      <div className="category-card">
        <div className="image-container">
          <img className="category-image" src="https://images.pexels.com/photos/4108729/pexels-photo-4108729.jpeg" alt="For-Home" />
        </div>
        <div className="category-link">
          <Link to="/category/kitchenware">Kitchenware</Link>
        </div>
      </div>


















    </div>
  );
};

export default HomeCategories;
