import React from 'react';
import Welcome from './HomePageComponents/Welcome';
import HomeCarousel from './HomePageComponents/Carousel';
import HomeCategories from './HomePageComponents/HomeCategories';
import CatchPhrase from './HomePageComponents/CatchPhrase';
import WhyChooseUs from './HomePageComponents/WhyChooseUs';
import Footer from './HomePageComponents/Footer';

const Home = () => (
  <div>
    <Welcome />
    <HomeCarousel />
    <HomeCategories />
    <CatchPhrase />
    <WhyChooseUs />
    <Footer />
  </div>
);

export default Home;
