import React from 'react';
import { Link } from 'react-router-dom';
import './HomeCategories.css';

const HomeCategories = () => {
  return (
    <div className="container">
      <h2 className="title">Explore our Wide Range of Products</h2>

      <div className="category-card">
        <div className="category-name" style={{ display: 'none' }}>Fruits</div>
        <div className="image-container">
          <img className="category-image" src="https://images.pexels.com/photos/5677917/pexels-photo-5677917.jpeg" alt="Fruits" />
        </div>
        <div className="category-link">
          <Link to="/category/apples">Apples</Link>
          <Link to="/category/lemons">Lemons</Link>
          <Link to="/category/cherries">Cherries</Link>
        </div>
      </div>

      <div className="category-card">
        <div className="image-container">
          <img className="category-image" src="https://cdn.pixabay.com/photo/2015/05/30/01/18/vegetables-790022_1280.jpg" alt="Vegetables" />
        </div>
        <div className="category-link">
          <Link to="/category/carrots">Carrots</Link>
          <Link to="/category/lettuce">Lettuce</Link>
          <Link to="/category/potatoes">Potatoes</Link>
        </div>
      </div>

      <div className="category-card">
        <div className="image-container">
          <img className="category-image" src="https://cdn.pixabay.com/photo/2015/05/25/16/14/burger-783551_1280.jpg" alt="Meat" />
        </div>
        <div className="category-link">
          <Link to="/category/chicken">Chicken</Link>
          <Link to="/category/beef">Beef</Link>
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
          <img className="category-image" src="https://images.pexels.com/photos/2531188/pexels-photo-2531188.jpeg" alt="Vegetables" />
        </div>
        <div className="category-link">
          <Link to="/category/alcoholic">Alcohol</Link>
          <Link to="/category/alcohol-free">Alcohol-free</Link>
        </div>
      </div>


      <div className="category-card">
        <div className="image-container">
          <img className="category-image" src="https://images.pexels.com/photos/1488467/pexels-photo-1488467.jpeg" alt="Vegetables" />
        </div>
        <div className="category-link">
          <Link to="/category/t-shirts">T-shirts</Link>
        </div>
      </div>


















    </div>
  );
};

export default HomeCategories;
