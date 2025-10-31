import React from 'react';
import { Menu } from 'antd';
import { Link, NavLink } from 'react-router-dom';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faShoppingCart } from '@fortawesome/free-solid-svg-icons';
import './Navbar.css';

const { SubMenu } = Menu;

function NavigationBar() {
  return (
    <Menu mode="horizontal" theme="dark" className="z-menu">
      <Menu.Item key="home" className="brand">
        <Link to="/">Zef's SHOP</Link>
      </Menu.Item>

      <SubMenu key="fruits-vegetables" title="Fruits & Vegetables">
        <Menu.Item key="apples"><NavLink to="/category/apples">Apples</NavLink></Menu.Item>
        <Menu.Item key="lemons"><NavLink to="/category/lemons">Lemons</NavLink></Menu.Item>
        <Menu.Item key="cherries"><NavLink to="/category/cherries">Cherries</NavLink></Menu.Item>
        <Menu.Item key="carrots"><NavLink to="/category/carrots">Carrots</NavLink></Menu.Item>
        <Menu.Item key="lettuce"><NavLink to="/category/lettuce">Lettuce</NavLink></Menu.Item>
      </SubMenu>

      <SubMenu key="bread-bakery" title="Bread & Bakery">
        <Menu.Item key="bread"><NavLink to="/category/bread">Bread</NavLink></Menu.Item>
        <Menu.Item key="bagels"><NavLink to="/category/bagels">Bagels</NavLink></Menu.Item>
        <Menu.Item key="baguettes"><NavLink to="/category/baguettes">Baguettes</NavLink></Menu.Item>
      </SubMenu>

      <SubMenu key="meat-fish" title="Meat & Fish">
        <Menu.Item key="chicken"><NavLink to="/category/chicken">Chicken</NavLink></Menu.Item>
        <Menu.Item key="beef"><NavLink to="/category/beef">Beef</NavLink></Menu.Item>
        <Menu.Item key="fish"><NavLink to="/category/fish">Fish</NavLink></Menu.Item>
      </SubMenu>

      <SubMenu key="sweets" title="Sweets">
        <Menu.Item key="chocolate"><NavLink to="/category/chocolate">Chocolate</NavLink></Menu.Item>
        <Menu.Item key="candy"><NavLink to="/category/candy">Candy</NavLink></Menu.Item>
        <Menu.Item key="ice-cream"><NavLink to="/category/ice-cream">Ice‑Cream</NavLink></Menu.Item>
      </SubMenu>

      <SubMenu key="beverages" title="Beverages">
        <Menu.Item key="alcohol"><NavLink to="/category/alcoholic">Alcohol</NavLink></Menu.Item>
        <Menu.Item key="alcohol-free"><NavLink to="/category/alcohol-free">Alcohol‑free</NavLink></Menu.Item>
      </SubMenu>

      <SubMenu key="for-home" title="For Home">
        <Menu.Item key="kitchenware"><NavLink to="/category/kitchenware">Kitchenware</NavLink></Menu.Item>
      </SubMenu>

      <Menu.Item key="cart" className="cart">
        <Link to="/cart">
          <FontAwesomeIcon icon={faShoppingCart} className="cart-icon" />
          {/* <span className="cart-text"> Cart</span> */}
        </Link>
      </Menu.Item>
    </Menu>
  );
}

export default NavigationBar;
