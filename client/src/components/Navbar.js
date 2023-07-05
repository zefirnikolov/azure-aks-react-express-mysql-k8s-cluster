import React from 'react';
import { Menu } from 'antd';
import { Link } from 'react-router-dom';
import './Navbar.css';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faShoppingCart } from '@fortawesome/free-solid-svg-icons';

const { SubMenu } = Menu;

function NavigationBar() {
  return (
    <Menu mode="horizontal" theme="dark" style={{ display: 'flex', justifyContent: 'space-between' }}>
      <Menu.Item key="home" style={{ fontSize: '2.5em', fontFamily: 'Brush Script MT'}}>
        <Link to="/">Zef's SHOP</Link> 
      </Menu.Item>

      <SubMenu key="fruits-vegetables" title="Fruits & Vegetables">
        <Menu.Item key="apples">
          <Link to="/category/apples">Apples</Link>
        </Menu.Item>
        <Menu.Item key="lemons">
          <Link to="/category/lemons">Lemons</Link>
        </Menu.Item>
        <Menu.Item key="cherries">
          <Link to="/category/cherries">Cherries</Link>
        </Menu.Item>
        <Menu.Item key="carrots">
          <Link to="/category/carrots">Carrots</Link>
        </Menu.Item>
        <Menu.Item key="lettuce">
          <Link to="/category/lettuce">Lettuce</Link>
        </Menu.Item>
        <Menu.Item key="potatoes">
          <Link to="/category/potatoes">Potatoes</Link>
        </Menu.Item>
      </SubMenu>

      <SubMenu key="bread-bakery" title="Bread & Bakery">
      <Menu.Item key="bread">
          <Link to="/category/bread">Bread</Link>
        </Menu.Item>
        <Menu.Item key="bagels">
          <Link to="/category/bagels">Bagels</Link>
        </Menu.Item>
        <Menu.Item key="rolls">
          <Link to="/category/rolls">Rolls</Link>
        </Menu.Item>
      </SubMenu>

      <SubMenu key="meat-fish" title="Meat & Fish">
        <Menu.Item key="chicken">
          <Link to="/category/chicken">Chicken</Link>
        </Menu.Item>
        <Menu.Item key="beef">
          <Link to="/category/beef">Beef</Link>
        </Menu.Item>
        <Menu.Item key="chicken">
          <Link to="/category/fish">Fish</Link>
        </Menu.Item>
      </SubMenu>

      <SubMenu key="sweets" title="Sweets">
        <Menu.Item key="chocolate">
          <Link to="/category/chocolate">Chocolate</Link>
        </Menu.Item>
        <Menu.Item key="candy">
          <Link to="/category/candy">Candy</Link>
        </Menu.Item>
        <Menu.Item key="icecream">
          <Link to="/category/ice-cream">Ice-Cream</Link>
        </Menu.Item>
      </SubMenu>

      <SubMenu key="beverages" title="Beverages">
        <Menu.Item key="alcoholic">
          <Link to="/category/alcoholic">Alcohol</Link>
        </Menu.Item>
        <Menu.Item key="alcohol-free">
          <Link to="/category/alcohol-free">Alcohol-free</Link>
        </Menu.Item>
      </SubMenu>

      <SubMenu key="for-home" title="For Home">
        <Menu.Item key="for-home">
          <Link to="/category/dishes">Dishes</Link>
        </Menu.Item>
      </SubMenu>

      <Menu.Item key="cart" className="navbar-right">
        <Link to="/cart">
          <FontAwesomeIcon icon={faShoppingCart} size="xl"/> Cart
        </Link>
      </Menu.Item>
    </Menu>
  );
}

export default NavigationBar;
