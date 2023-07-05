import React, { useContext, useState, useEffect } from 'react';
import { useParams, Link } from 'react-router-dom';
import { CartContext } from '../CartContext';
import './ProductPage.css';

const ProductsPage = () => {
  let { productName } = useParams();
  const [products, setProducts] = useState([]);
  const [message, setMessage] = useState(null);
  const { cart, addToCart } = useContext(CartContext);

  useEffect(() => {
    fetch("/api/products")
      .then(response => response.json())
      .then(data => setProducts(data))
      .catch(err => console.log(err));
  }, []); 

  const handleAddToCart = (product, quantity, imageUrl) => {
    quantity = parseInt(quantity);
    const existingProduct = cart.find(p => p.name === product.name);
    if (existingProduct && existingProduct.quantity + quantity > 20) {
      setMessage(`Cannot add more. The maximum limit of 20 is reached. Your current quantity is: ${existingProduct.quantity}`);
    } else {
      addToCart(product, quantity, imageUrl);
      setMessage('Added to cart!');
    }
    setTimeout(() => setMessage(null), 3000);
  };

  const productData = {
    'apples': {
      header: 'Apples',
      description: 'Select from our range of fresh Apples',
      imageUrls: [
        "https://images.pexels.com/photos/693794/pexels-photo-693794.jpeg",
        "https://images.pexels.com/photos/2966150/pexels-photo-2966150.jpeg"
      ],
      packageDetails: 'Apples 1kg package:'
    },
    'lemons': {
      header: 'Lemons',
      description: 'Select from our range of fresh Lemons',
      imageUrls: [
        "https://images.pexels.com/photos/266346/pexels-photo-266346.jpeg",
        "https://images.pexels.com/photos/2363347/pexels-photo-2363347.jpeg"
      ],
      packageDetails: 'Lemons 1kg package:'
    },
    'cherries': {
      header: 'Cherries',
      description: "Select from our range of fresh Cherries",
      imageUrls: [
        "https://images.pexels.com/photos/966416/pexels-photo-966416.jpeg",
      ],
      packageDetails: 'Cherries 1kg package:'
    },
    'carrots': {
      header: 'Carrots',
      description: "Select from our range of fresh Carrots",
      imageUrls: [
        "https://cdn.pixabay.com/photo/2019/01/16/21/14/carrot-3936797_1280.jpg",
        "https://cdn.pixabay.com/photo/2017/07/31/03/46/carrot-2556382_1280.jpg"
      ],
      packageDetails: 'Carrots 1kg package:'
    },       
    'lettuce': {
      header: 'Lettuce',
      description: "Select from our range of fresh Lettuce",
      imageUrls: [
        "https://images.pexels.com/photos/3016319/pexels-photo-3016319.jpeg",
      ],
      packageDetails: 'Lettuce 1 head:'
    },
    'potatoes': {
      header: 'Potatoes',
      description: "Select from our range of fresh Potatoes",
      imageUrls: [
        "https://images.pexels.com/photos/2286776/pexels-photo-2286776.jpeg",
        "https://images.pexels.com/photos/10652321/pexels-photo-10652321.jpeg"
      ],
      packageDetails: 'Potatoes 1kg package:'
    },
    'chicken': {
      header: 'Chicken',
      description: "Select from our range of great Chicken",
      imageUrls: [
        "https://images.pexels.com/photos/616354/pexels-photo-616354.jpeg",
        "https://images.pexels.com/photos/10842249/pexels-photo-10842249.jpeg"
      ],
      packageDetails: 'whole Chicken:'
    },
    'beef': {
      header: 'Beef',
      description: "Select from our range of great Beef",
      imageUrls: [
        "https://images.pexels.com/photos/6542794/pexels-photo-6542794.jpeg",
        "https://cdn.pixabay.com/photo/2017/10/22/20/21/meat-2879151_1280.jpg"
      ],
      packageDetails: 'Beef 500gr piece:'
    },
    'chocolate': {
      header: 'Chocolate',
      description: "Select from our range of great Chocolate",
      imageUrls: [
        "https://images.pexels.com/photos/7538069/pexels-photo-7538069.jpeg",
        "https://images.pexels.com/photos/14000579/pexels-photo-14000579.jpeg"
      ],
      packageDetails: 'Chocolate pack:'
    },
    'candy': {
      header: 'Candy',
      description: "Select from our range of great Candy",
      imageUrls: [
        "https://images.pexels.com/photos/55825/gold-bear-gummi-bears-bear-yellow-55825.jpeg",
        "https://images.pexels.com/photos/4016512/pexels-photo-4016512.jpeg"
      ],
      packageDetails: 'Candy 1kg package:'
    },
    'ice-cream': {
      header: 'Ice-cream',
      description: "Select from our range of great Ice-cream",
      imageUrls: [
        "https://images.pexels.com/photos/1294943/pexels-photo-1294943.jpeg",
        "https://images.pexels.com/photos/3883858/pexels-photo-3883858.jpeg"
      ],
      packageDetails: 'Ice-cream pack:'
    },
    'alcoholic': {
      header: 'Alcohol',
      description: "Select from our range of great Alcoholic beverages",
      imageUrls: [
        "https://images.pexels.com/photos/7253621/pexels-photo-7253621.jpeg",
        "https://images.pexels.com/photos/2820146/pexels-photo-2820146.jpeg"
      ],
      packageDetails: 'Bottle:'
    },
    'alcohol-free': {
      header: 'Alcohol-free',
      description: "Select from our range of great Alcohol-free beverages",
      imageUrls: [
        "https://images.pexels.com/photos/1000084/pexels-photo-1000084.jpeg",
        "https://images.pexels.com/photos/3651045/pexels-photo-3651045.jpeg"
      ],
      packageDetails: 'Alcohol-free bottle:'
    },
    't-shirts': {
      header: 'T-shirts',
      description: "Select from our range of great T-shirts",
      imageUrls: [
        "https://images.pexels.com/photos/8148577/pexels-photo-8148577.jpeg",
      ],
      packageDetails: 'T-shirt:'
    },
  };

  const renderProduct = (productName) => {
    const productInfo = productData[productName];
    if(productInfo) {
      return (
        <div className="product-page">
          <h1>{productInfo.header}</h1>
          <p>{productInfo.description}</p>
          {message && <p className="message">{message}</p>}
          {products.filter(product => product.name.includes(productName.slice(0, -1))).map((product, index) => (
            <div key={product.id} className="product-offer">
              <img src={productInfo.imageUrls[index]} alt={product.name}/>              
              <p>Offer #{index+1} - {productInfo.packageDetails} <span className="product-price">${product.price}</span> X  </p>
              <select id={`quantity-${product.id}`}>
                {[...Array(20)].map((_, i) => <option key={i} value={i+1}>{i+1}</option>)}
              </select>
              <button onClick={() => handleAddToCart(product, document.getElementById(`quantity-${product.id}`).value, productInfo.imageUrls[index])}>Add to cart</button>
            </div>
          ))}
          <Link to="/cart" className="cart-link">Go to the Shopping Cart</Link>
        </div>
      );
    } else {
      return <div style={{
        display: 'flex',
        justifyContent: 'center',
        alignItems: 'center',
        height: '100vh',
        backgroundImage: `url(https://cdn.pixabay.com/photo/2017/06/08/17/32/not-found-2384304_1280.jpg)`,
        backgroundPosition: 'center',
        backgroundSize: 'cover',
        backgroundRepeat: 'no-repeat'
      }}>
      </div>
    }
  }  

  return (
    <div>
      {renderProduct(productName)}
    </div>
  );
};

export default ProductsPage;
