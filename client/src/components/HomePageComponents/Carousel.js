import React from 'react';
import Carousel from 'react-bootstrap/Carousel';
import Button from 'react-bootstrap/Button';
import { Link } from 'react-router-dom';
import './Carousel.css';

function HomeCarousel() {
  return (
    <Carousel>
      <Carousel.Item>
        <img
          className="d-block w-100 carousel-image"
          src="https://images.pexels.com/photos/13262362/pexels-photo-13262362.jpeg"
          alt="Second slide"
        />
      <Carousel.Caption>
        <h3>Greens at Their Best</h3>
        <p>Sourced locally for your guilt-free indulgence.</p>
        <Link to="/category/lettuce">
          <Button variant="primary">Shop Now</Button>
        </Link>
      </Carousel.Caption>
      </Carousel.Item>
      <Carousel.Item>
        <img
          className="d-block w-100 carousel-image"
          src="https://images.pexels.com/photos/966416/pexels-photo-966416.jpeg"
          alt="First slide"
        />
      <Carousel.Caption>
        <h3>Freshly Picked Cherries</h3>
        <p>Available from two different farms.</p>
        <Link to="/category/cherries">
          <Button variant="primary">Shop Now</Button>
        </Link>
      </Carousel.Caption>
      </Carousel.Item>

      <Carousel.Item>
        <img
          className="d-block w-100 carousel-image"
          src="https://images.pexels.com/photos/65175/pexels-photo-65175.jpeg"
          alt="Third slide"
        />
      <Carousel.Caption>
        <h3>Premium Quality Beef Steaks</h3>
        <p>Perfect for your next BBQ.</p>
        <Link to="/category/beef">
          <Button variant="primary">Shop Now</Button>
        </Link>
      </Carousel.Caption>
      </Carousel.Item>
    </Carousel>
  );
}

export default HomeCarousel;
