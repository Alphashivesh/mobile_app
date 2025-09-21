const express = require('express');
const cors = require('cors');
require('dotenv').config();
const db = require('./db');
const bcrypt = require('bcrypt');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

app.get('/api/categories', async (req, res) => {
  try {
    const [rows] = await db.query('SELECT * FROM categories');
    res.json(rows);
  } catch (error) {
    console.error("Failed to fetch categories:", error);
    res.status(500).json({ error: 'Database query failed' });
  }
});

app.post('/api/banquet-requests', async (req, res) => {
  try {
    const {
      eventType, country, state, city, eventDates, numAdults, cateringPreference, cuisines, budget, currency, offerWithinHours
    } = req.body;

    const sql = `INSERT INTO banquet_requests (event_type, country, state, city, event_dates, num_adults, catering_preference, cuisines, budget, currency, offer_within_hours) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`;

    const values = [eventType, country, state, city, eventDates, numAdults, cateringPreference, cuisines, budget, currency, offerWithinHours];

    await db.query(sql, values);
    res.status(201).json({ message: 'Request submitted successfully!' });

  } catch (error) {
    console.error("Failed to submit request:", error);
    res.status(500).json({ error: 'Failed to submit request' });
  }
});

app.post('/api/saloon-requests', async (req, res) => {
  try {
    const {
      serviceType,
      preferredDate,
      preferredTime,
      customerGender,
      stylistPreference,
      budget,             
      specialRequests
    } = req.body;

    const sql = `INSERT INTO saloon_requests (service_type, preferred_date, preferred_time, customer_gender, stylist_preference, budget, special_requests) VALUES (?, ?, ?, ?, ?, ?, ?)`;
    const values = [serviceType, preferredDate, preferredTime, customerGender, stylistPreference, budget, specialRequests];

    await db.query(sql, values);
    res.status(201).json({ message: 'Saloon request submitted successfully!' });

  } catch (error) {
    console.error("Failed to submit saloon request:", error);
    res.status(500).json({ error: 'Failed to submit saloon request' });
  }
});

app.post('/api/gym-requests', async (req, res) => {
  try {
    const {
      activityType,
      durationMonths,
      customerGender,
      intensityLevel,
      focusArea,
      workoutGoal,
      equipmentUsed,
      nutritionLink,
      location,
      specialRequests
    } = req.body;

    const sql = `INSERT INTO gym_requests (activity_type, duration_months, customer_gender, intensity_level, focus_area, workout_goal, equipment_used, nutrition_link, location, special_requests) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`;
    const values = [activityType, durationMonths, customerGender, intensityLevel, focusArea, workoutGoal, equipmentUsed, nutritionLink, location, specialRequests];

    await db.query(sql, values);
    res.status(201).json({ message: 'Gym request submitted successfully!' });

  } catch (error) {
    console.error("Failed to submit gym request:", error);
    res.status(500).json({ error: 'Failed to submit gym request' });
  }
});

app.post('/api/travel-requests', async (req, res) => {
  try {
    const {
      country,
      state,
      destinationCity,
      checkInDate,
      checkOutDate,
      numTravelers,
      numRooms,
      numChildren,
      travelerType,
      accommodationType,
      budget,
      currency,
      offerWithinHours
    } = req.body;

    const sql = `INSERT INTO travel_requests (country, state, destination_city, check_in_date, check_out_date, num_travelers, num_rooms, num_children, traveler_type, accommodation_type, budget, currency, offer_within_hours) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`;
    const values = [country, state, destinationCity, checkInDate, checkOutDate, numTravelers, numRooms, numChildren, travelerType, accommodationType, budget, currency, offerWithinHours];

    await db.query(sql, values);
    res.status(201).json({ message: 'Travel request submitted successfully!' });

  } catch (error) {
    console.error("Failed to submit travel request:", error);
    res.status(500).json({ error: 'Failed to submit travel request' });
  }
});

app.post('/api/retail-requests', async (req, res) => {
  try {
    const {
      productCategory,
      itemDescription,
      quantity,
      brandPreference,
      itemCondition,
      deliveryLocation,
      budget,
      currency,
      offerWithinHours
    } = req.body;

    const sql = `INSERT INTO retail_requests (product_category, item_description, quantity, brand_preference, item_condition, delivery_location, budget, currency, offer_within_hours) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`;
    const values = [productCategory, itemDescription, quantity, brandPreference, itemCondition, deliveryLocation, budget, currency, offerWithinHours];

    await db.query(sql, values);
    res.status(201).json({ message: 'Retail request submitted successfully!' });

  } catch (error) {
    console.error("Failed to submit retail request:", error);
    res.status(500).json({ error: 'Failed to submit retail request' });
  }
});

app.post('/api/jewelry-requests', async (req, res) => {
  try {
    const {
      itemType,
      material,
      gemstone,
      sizeDetails,
      customizationDetails,
      designReferenceUrl,
      occasion,
      budget,
      currency,
      deliveryDeadline
    } = req.body;

    const sql = `INSERT INTO jewelry_requests (item_type, material, gemstone, size_details, customization_details, design_reference_url, occasion, budget, currency, delivery_deadline) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`;
    const values = [itemType, material, gemstone, sizeDetails, customizationDetails, designReferenceUrl, occasion, budget, currency, deliveryDeadline];

    await db.query(sql, values);
    res.status(201).json({ message: 'Jewelry request submitted successfully!' });

  } catch (error) {
    console.error("Failed to submit jewelry request:", error);
    res.status(500).json({ error: 'Failed to submit jewelry request' });
  }
});

app.post('/api/fashion-requests', async (req, res) => {
  try {
    const {
      clothingType,
      size,
      colorPreference,
      fabricType,
      patternOrStyle,
      brandPreference,
      gender,
      occasion,
      occasionType,
      budget,
      currency,
      preferredDate,
      additionalNotes
    } = req.body;

    const sql = `INSERT INTO fashion_requests (clothing_type, size, color_preference, fabric_type, pattern_or_style, brand_preference, gender, occasion, occasion_type, budget, currency, preferred_date, additional_notes) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`;
    const values = [clothingType, size, colorPreference, fabricType, patternOrStyle, brandPreference, gender, occasion, occasionType, budget, currency, preferredDate, additionalNotes];

    await db.query(sql, values);
    res.status(201).json({ message: 'Fashion request submitted successfully!' });

  } catch (error) {
    console.error("Failed to submit fashion request:", error);
    res.status(500).json({ error: 'Failed to submit fashion request' });
  }
});

app.post('/api/gifts-requests', async (req, res) => {
  try {
    const {
      occasion,
      recipientGender,
      recipientAgeGroup,
      recipientRelation,
      giftCategory,
      giftType,
      priceRange,
      currency,
      personalizationDetails,
      preferredBrands,
      preferredDate,
      urgencyLevel,
      additionalNotes
    } = req.body;

    const sql = `INSERT INTO gifts_requests (occasion, recipient_gender, recipient_age_group, recipient_relation, gift_category, gift_type, price_range, currency, personalization_details, preferred_brands, preferred_date, urgency_level, additional_notes) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`;
    const values = [occasion, recipientGender, recipientAgeGroup, recipientRelation, giftCategory, giftType, priceRange, currency, personalizationDetails, preferredBrands, preferredDate, urgencyLevel, additionalNotes];

    await db.query(sql, values);
    res.status(201).json({ message: 'Gifts request submitted successfully!' });

  } catch (error) {
    console.error("Failed to submit gifts request:", error);
    res.status(500).json({ error: 'Failed to submit gifts request' });
  }
});

app.post('/api/memories-requests', async (req, res) => {
  try {
    const {
      eventType,
      serviceType,
      eventDate,
      location,
      themeOrMood,
      guestCount,
      budget,
      currency,
      preferredPhotographer,
      mediaTypes,
      specialRequests,
      additionalNotes
    } = req.body;

    const sql = `INSERT INTO memories_requests (event_type, service_type, event_date, location, theme_or_mood, guest_count, budget, currency, preferred_photographer, media_types, special_requests, additional_notes) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`;
    const values = [eventType, serviceType, eventDate, location, themeOrMood, guestCount, budget, currency, preferredPhotographer, mediaTypes, specialRequests, additionalNotes];

    await db.query(sql, values);
    res.status(201).json({ message: 'Memories request submitted successfully!' });

  } catch (error) {
    console.error("Failed to submit memories request:", error);
    res.status(500).json({ error: 'Failed to submit memories request' });
  }
});

app.post('/api/craft-requests', async (req, res) => {
  try {
    const {
      craftType,
      description,
      materialType,
      colorPreferences,
      sizeOrDimensions,
      quantity,
      budget,
      currency,
      personalizationDetails,
      preferredDate,
      additionalNotes
    } = req.body;

    const sql = `INSERT INTO craft_requests (craft_type, description, material_type, color_preferences, size_or_dimensions, quantity, budget, currency, personalization_details, preferred_date, additional_notes) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`;
    const values = [craftType, description, materialType, colorPreferences, sizeOrDimensions, quantity, budget, currency, personalizationDetails, preferredDate, additionalNotes];

    await db.query(sql, values);
    res.status(201).json({ message: 'Craft request submitted successfully!' });

  } catch (error) {
    console.error("Failed to submit craft request:", error);
    res.status(500).json({ error: 'Failed to submit craft request' });
  }
});

app.post('/api/smart-services-requests', async (req, res) => {
  try {
    const { serviceCategory, description, preferredDate, timeSlot, budget, currency, additionalNotes } = req.body;
    const sql = `INSERT INTO smart_services_requests (service_category, description, preferred_date, time_slot, budget, currency, additional_notes) VALUES (?, ?, ?, ?, ?, ?, ?)`;
    const values = [serviceCategory, description, preferredDate, timeSlot, budget, currency, additionalNotes];
    await db.query(sql, values);
    res.status(201).json({ message: 'Service request submitted successfully!' });
  } catch (error) {
    console.error("Failed to submit service request:", error);
    res.status(500).json({ error: 'Failed to submit service request' });
  }
});

app.post('/api/games-requests', async (req, res) => {
  try {
    const { gameType, numPlayers, ageGroup, locationType, locationDetails, eventDate, eventTime, budget, currency, equipmentNeeded, additionalNotes } = req.body;
    const sql = `INSERT INTO games_requests (game_type, num_players, age_group, location_type, location_details, event_date, event_time, budget, currency, equipment_needed, additional_notes) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`;
    const values = [gameType, numPlayers, ageGroup, locationType, locationDetails, eventDate, eventTime, budget, currency, equipmentNeeded, additionalNotes];
    await db.query(sql, values);
    res.status(201).json({ message: 'Game request submitted successfully!' });
  } catch (error) {
    console.error("Failed to submit game request:", error);
    res.status(500).json({ error: 'Failed to submit game request' });
  }
});

app.post('/api/register', async (req, res) => {
  try {
    const { name, email, password } = req.body;

    // Hash the password before storing it
    const saltRounds = 10;
    const hashedPassword = await bcrypt.hash(password, saltRounds);

    const sql = `INSERT INTO users (name, email, password) VALUES (?, ?, ?)`;
    const values = [name, email, hashedPassword];

    await db.query(sql, values);
    res.status(201).json({ message: 'User registered successfully!' });

  } catch (error) {
    if (error.code === 'ER_DUP_ENTRY') {
      return res.status(409).json({ error: 'Email already exists.' });
    }
    console.error("Failed to register user:", error);
    res.status(500).json({ error: 'Failed to register user' });
  }
});

app.post('/api/login', async (req, res) => {
  try {
    const { email, password } = req.body;

    const sql = `SELECT * FROM users WHERE email = ?`;
    const [users] = await db.query(sql, [email]);

    if (users.length === 0) {
      return res.status(401).json({ error: 'Invalid email or password' });
    }

    const user = users[0];

    const isMatch = await bcrypt.compare(password, user.password);

    if (!isMatch) {
      return res.status(401).json({ error: 'Invalid email or password' });
    }

    res.json({ message: 'Login successful!', user: { name: user.name, email: user.email } });

  } catch (error) {
    console.error("Failed to log in user:", error);
    res.status(500).json({ error: 'Failed to log in user' });
  }
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});