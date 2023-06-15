-- Create DB
DROP SCHEMA IF EXISTS recipe_generator;
CREATE DATABASE recipe_generator CHARACTER SET utf8 COLLATE utf8_general_ci;
-- Create user and grant access
DROP USER 'recipe_app'@'%';
FLUSH PRIVILEGES;
CREATE USER 'recipe_app'@'%' IDENTIFIED BY 'GetANewPassword1!';
GRANT SELECT, INSERT, UPDATE, DELETE ON recipe_generator.* TO 'recipe_app'@'%';

-- Generate tables 
USE recipe_generator;

DROP TABLE IF EXISTS user_includes;
DROP TABLE IF EXISTS user_excludes;
DROP TABLE IF EXISTS user;
DROP TABLE IF EXISTS recipe_ingredients;
DROP TABLE IF EXISTS ingredient;
DROP TABLE IF EXISTS product_group;
DROP TABLE IF EXISTS recipe;
DROP TABLE IF EXISTS cuisine;
  
CREATE TABLE user (
id int not null auto_increment,
email varchar(255) not null,
password varchar(255) not null,
name varchar(255),
surname varchar(255),
is_admin boolean,
PRIMARY KEY (id)
);

CREATE TABLE cuisine (
id int not null auto_increment,
name varchar(25),
PRIMARY KEY (id)
);

CREATE TABLE recipe (
id int not null auto_increment,
cuisine_id int,
title varchar(255) not null,
prep_time varchar(25),
instructions varchar(2000),
PRIMARY KEY (id)
);

CREATE TABLE ingredient(
id int not null auto_increment,
name varchar(50) not null,
group_id int,
energy100g float,
fat varchar(20),
carbohydrates varchar(20),
protein varchar(20),
vitamines varchar(50),
minerals varchar(255),
instore boolean,
PRIMARY KEY (id)
);

CREATE TABLE product_group (
id int auto_increment,
name varchar(50),
PRIMARY KEY (id)
);

CREATE TABLE recipe_ingredients (
recipe_id int,
ingredient_id int,
amount varchar(25)
);
CREATE TABLE user_includes (
user_id int,
ingredient_id int,
group_id int,
cuisine_id int
);

CREATE TABLE user_excludes (
user_id int,
ingredient_id int,
group_id int,
cuisine_id int
);

ALTER TABLE recipe ADD CONSTRAINT fk_recipe_cuisine  FOREIGN KEY (cuisine_id)   REFERENCES cuisine(id)  ON DELETE CASCADE;  
ALTER TABLE ingredient  ADD CONSTRAINT fk_ingredient_group  FOREIGN KEY (group_id)  REFERENCES product_group(id)  ON DELETE CASCADE;  
ALTER TABLE recipe_ingredients  ADD CONSTRAINT fk_rec_ingr_rec  FOREIGN KEY (recipe_id)  REFERENCES recipe(id)  ON DELETE CASCADE;
ALTER TABLE recipe_ingredients  ADD CONSTRAINT fk_rec_ingr_ingr  FOREIGN KEY (ingredient_id)  REFERENCES ingredient(id)  ON DELETE CASCADE;
ALTER TABLE user_includes  ADD CONSTRAINT fk_usr_inc_usr  FOREIGN KEY (user_id)  REFERENCES user(id)  ON DELETE CASCADE;  
ALTER TABLE user_includes  ADD CONSTRAINT fk_usr_inc_ingr  FOREIGN KEY (ingredient_id)  REFERENCES ingredient(id)  ON DELETE CASCADE;   
ALTER TABLE user_includes  ADD CONSTRAINT fk_usr_inc_group  FOREIGN KEY (group_id)  REFERENCES product_group(id)  ON DELETE CASCADE;   
ALTER TABLE user_includes  ADD CONSTRAINT fk_usr_inc_cui  FOREIGN KEY (cuisine_id)  REFERENCES cuisine(id)  ON DELETE CASCADE;  
ALTER TABLE user_excludes  ADD CONSTRAINT fk_usr_exc_usr  FOREIGN KEY (user_id)  REFERENCES user(id)  ON DELETE CASCADE;  
ALTER TABLE user_excludes  ADD CONSTRAINT fk_usr_exc_ingr  FOREIGN KEY (ingredient_id)  REFERENCES ingredient(id)  ON DELETE CASCADE;   
ALTER TABLE user_excludes  ADD CONSTRAINT fk_usr_exc_group  FOREIGN KEY (group_id)  REFERENCES product_group(id)  ON DELETE CASCADE;   
ALTER TABLE user_excludes  ADD CONSTRAINT fk_usr_exc_cui  FOREIGN KEY (cuisine_id)  REFERENCES cuisine(id)  ON DELETE CASCADE;  

-- Populate tables with sample data

INSERT INTO cuisine (name) 
VALUES 
   ('Italian'),
   ('Chinese'),
   ('French'),
   ('Greek'),
   ('Indian'),
   ('International');
  
INSERT INTO product_group (name) 
VALUES 
   ('Meat'),
   ('Fish and sea produce'),
   ('Vegetables and fruit'),
   ('Diary'),
   ('Grain'),
   ('Legumes'),
   ('Eggs'),
   ('Nuts and seeds'),
   ('Unclasified');
 
INSERT INTO ingredient (name, group_id, energy100g, fat, carbohydrates, protein, vitamines, minerals, instore)
VALUES
  ('Milk', 4, 60.0, '3.5g', '4.7g', '3.3g', 'Vitamin A, Vitamin D', 'Calcium, Potassium', true),
  ('Bread', 5, 250.0, '2.5g', '49.5g', '8.0g', 'Vitamin B1, Vitamin B2', 'Iron, Calcium', true),
  ('Chicken Breast', 4, 165.0, '3.6g', '0.0g', '31.0g', 'Vitamin B6, Vitamin B12', 'Iron, Zinc', true),
  ('Rice', 5, 130.0, '0.3g', '28.0g', '2.7g', 'Thiamin, Niacin', 'Iron, Magnesium', true),
  ('Tomatoes', 3, 18.0, '0.2g', '3.9g', '0.9g', 'Vitamin C, Vitamin K', 'Potassium, Manganese', true),
  ('Apples', 3, 52.0, '0.2g', '14.0g', '0.3g', 'Vitamin C', 'Potassium', true),
  ('Eggs', 7, 143.0, '9.5g', '0.6g', '12.6g', 'Vitamin B2, Vitamin B5', 'Iron, Zinc', true),
  ('Salmon', 2, 206.0, '13.0g', '0.0g', '22.0g', 'Vitamin D', 'Potassium, Selenium', true),
  ('Spinach', 3, 23.0, '0.4g', '3.6g', '2.9g', 'Vitamin A, Vitamin C', 'Iron, Magnesium', true),
  ('Yogurt', 4, 59.0, '0.4g', '3.6g', '10.0g', 'Calcium, Vitamin B12', 'Phosphorus', true),
  ('Bananas', 3, 96.0, '0.2g', '23.0g', '1.1g', 'Vitamin C, Vitamin B6', 'Potassium, Magnesium', false),
  ('Cheese', 4, 402.0, '33.0g', '1.3g', '25.0g', 'Calcium, Vitamin B12', 'Phosphorus, Zinc', true),
  ('Potatoes', 3, 77.0, '0.1g', '17.5g', '2.0g', 'Vitamin C, Vitamin B6', 'Potassium, Magnesium', true),
  ('Carrots', 3, 41.0, '0.2g', '9.6g', '0.9g', 'Vitamin A, Vitamin K', 'Potassium, Iron', true),
  ('Onions', 3, 40.0, '0.1g', '9.3g', '1.1g', 'Vitamin C, Folate', 'Potassium, Calcium', true),
  ('Oats', 5, 389.0, '6.9g', '66.3g', '16.9g', 'Thiamin, Niacin', 'Iron, Magnesium', true),
  ('Oranges', 3, 43.0, '0.1g', '8.3g', '0.9g', 'Vitamin C', 'Calcium', true),
  ('Lettuce', 3, 5.0, '0.1g', '1.0g', '0.5g', 'Vitamin A, Vitamin K', 'Iron, Calcium', true),
  ('Beef', 1, 250.0, '20.0g', '0.0g', '26.0g', 'Vitamin B6, Vitamin B12', 'Iron, Zinc', true),
  ('Pasta', 5, 131.0, '1.1g', '26.0g', '5.5g', 'Thiamin, Niacin', 'Iron, Magnesium', true),
  ('Strawberries', 3, 32.0, '0.3g', '7.7g', '0.7g', 'Vitamin C', 'Potassium', true),
  ('Peanut Butter', 8, 588.0, '50.0g', '20.0g', '25.0g', 'Vitamin E', 'Magnesium', true),
  ('Cucumber', 3, 15.0, '0.1g', '3.6g', '0.7g', 'Vitamin K', 'Potassium', true),
  ('Avocado', 3, 160.0, '14.7g', '8.5g', '2.0g', 'Vitamin K, Vitamin E', 'Potassium, Magnesium', true),
  ('Honey', 9, 304.0, '0.0g', '82.0g', '0.3g', 'Vitamin C', 'Calcium, Iron', true),
  ('Almonds', 8, 579.0, '50.6g', '21.6g', '21.2g', 'Vitamin E', 'Magnesium, Calcium', true),
  ('Green Beans', 6, 31.0, '0.2g', '7.1g', '1.8g', 'Vitamin C, Vitamin K', 'Iron, Calcium', true),
  ('Blueberries', 3, 57.0, '0.3g', '14.5g', '0.7g', 'Vitamin C, Vitamin K', 'Potassium, Magnesium', true),
  ('Lemons', 3, 29.0, '0.3g', '9.3g', '1.1g', 'Vitamin C', 'Potassium, Calcium', true),
  ('Tofu', 9, 144.0, '8.0g', '1.9g', '15.0g', 'Calcium', 'Iron, Magnesium', true),
  ('Pineapple', 3, 50.0, '0.1g', '13.1g', '0.5g', 'Vitamin C', 'Manganese', true),
  ('Broccoli', 3, 34.0, '0.4g', '6.6g', '2.8g', 'Vitamin C, Vitamin K', 'Calcium, Iron', true),
  ('Bell Peppers', 3, 20.0, '0.2g', '4.6g', '0.9g', 'Vitamin C, Vitamin B6', 'Potassium, Magnesium', true),
  ('Shrimp', 2, 99.0, '0.3g', '0.0g', '24.0g', 'Vitamin B12', 'Selenium, Zinc', true),
  ('Quinoa', 5, 368.0, '6.1g', '64.2g', '14.1g', 'Thiamin, Riboflavin', 'Iron, Magnesium', true),
  ('Grapes', 3, 69.0, '0.2g', '17.0g', '0.6g', 'Vitamin C, Vitamin K', 'Potassium', true),
  ('Peaches', 3, 39.0, '0.3g', '9.5g', '0.9g', 'Vitamin C', 'Potassium', true),
  ('Black Beans', 6, 341.0, '1.4g', '62.0g', '21.6g', 'Thiamin, Folate', 'Iron, Magnesium', true),
  ('Cauliflower', 3, 25.0, '0.3g', '5.0g', '2.0g', 'Vitamin C, Vitamin K', 'Calcium, Iron', true),
  ('Lentils', 6, 116.0, '0.4g', '20.0g', '9.0g', 'Thiamin, Niacin', 'Iron, Potassium', true),
  ('Watermelon', 3, 30.0, '0.2g', '8.0g', '0.6g', 'Vitamin C', 'Potassium', true),
  ('Mangoes', 3, 60.0, '0.4g', '15.0g', '0.8g', 'Vitamin C, Vitamin A', 'Potassium', true),
  ('Cabbage', 3, 25.0, '0.1g', '5.8g', '1.3g', 'Vitamin C, Vitamin K', 'Calcium, Iron', true),
  ('Sweet Potatoes', 3, 86.0, '0.2g', '20.0g', '1.6g', 'Vitamin A, Vitamin C', 'Potassium, Calcium', true),
  ('Honeydew Melon', 3, 36.0, '0.1g', '9.1g', '0.5g', 'Vitamin C', 'Potassium', true),
  ('Cottage Cheese', 4, 72.0, '0.9g', '3.4g', '11.0g', 'Calcium, Vitamin B12', 'Phosphorus', true),
  ('Eggplant', 3, 25.0, '0.2g', '6.0g', '1.0g', 'Vitamin K', 'Potassium', true),
  ('Turkey', 1, 189.0, '8.0g', '0.0g', '29.0g', 'Vitamin B6, Vitamin B12', 'Iron, Zinc', true),
  ('Zucchini', 3, 17.0, '0.3g', '3.1g', '1.2g', 'Vitamin C', 'Potassium', true),
  ('Raspberries', 3, 52.0, '0.7g', '12.0g', '1.2g', 'Vitamin C', 'Manganese', true),
  ('Soy Milk', 9, 54.0, '1.8g', '3.9g', '3.3g', 'Vitamin B12, Vitamin D', 'Calcium, Iron', true),
  ('Pears', 3, 57.0, '0.1g', '15.0g', '0.4g', 'Vitamin C, Vitamin K', 'Potassium', true),
  ('Celery', 3, 16.0, '0.2g', '3.0g', '0.7g', 'Vitamin K', 'Potassium', true),
  ('Pork', 1, 242.0, '14.0g', '0.0g', '27.0g', 'Vitamin B6, Vitamin B12', 'Iron, Zinc', true),
  ('Pomegranate', 3, 83.0, '1.2g', '18.0g', '1.7g', 'Vitamin C', 'Potassium', true),
  ('Chickpeas', 6, 364.0, '6.0g', '63.0g', '19.0g', 'Folate, Vitamin B6', 'Iron, Magnesium', true),
  ('Asparagus', 3, 20.0, '0.2g', '3.7g', '2.2g', 'Vitamin K, Folate', 'Potassium, Calcium', true),
  ('Ground Beef', 1, 250.0, '20.0g', '0.0g', '26.0g', 'Vitamin B6, Vitamin B12', 'Iron, Zinc', true),
  ('Kiwi', 3, 61.0, '0.5g', '15.0g', '1.1g', 'Vitamin C, Vitamin K', 'Potassium', False),
  ('Olive Oil', 9, 884.0, '100.0g', '0.0g', '0.0g', 'Vitamin E', 'Sodium', true),
  ('Beets', 3, 43.0, '0.1g', '10.0g', '1.6g', 'Vitamin C, Folate', 'Potassium, Iron', true),
  ('Tuna', 2, 116.0, '0.8g', '0.0g', '26.0g', 'Vitamin D', 'Selenium, Magnesium', true),
  ('Green Peas', 3, 81.0, '0.4g', '14.0g', '5.0g', 'Vitamin C, Vitamin K', 'Iron, Magnesium', true),
  ('Lime', 3, 30.0, '0.1g', '10.5g', '0.7g', 'Vitamin C', 'Potassium', true),
  ('Cantaloupe', 3, 34.0, '0.2g', '8.2g', '0.8g', 'Vitamin C, Vitamin A', 'Potassium', true),
  ('Mushrooms', 3, 22.0, '0.3g', '3.3g', '3.1g', 'Vitamin D, Vitamin B2', 'Potassium', true),
  ('Coconut', 8, 354.0, '33.5g', '15.2g', '3.3g', 'Vitamin C', 'Iron, Magnesium', true),
  ('Radishes', 3, 16.0, '0.1g', '3.4g', '0.7g', 'Vitamin C', 'Potassium', true),
  ('Ground Turkey', 1, 189.0, '8.0g', '0.0g', '29.0g', 'Vitamin B6, Vitamin B12', 'Iron, Zinc', true),
  ('Apricots', 3, 48.0, '0.1g', '12.0g', '0.5g', 'Vitamin C, Vitamin A', 'Potassium', true),
  ('Swiss Chard', 3, 19.0, '0.2g', '3.7g', '1.8g', 'Vitamin K, Vitamin C', 'Magnesium', true),
  ('Greek Yogurt', 4, 97.0, '0.2g', '3.6g', '10.0g', 'Calcium, Vitamin B12', 'Phosphorus', true),
  ('Plums', 3, 46.0, '0.1g', '11.0g', '0.6g', 'Vitamin C', 'Potassium', true),
  ('Oranges', 3, 43.0, '0.2g', '9.2g', '1.0g', 'Vitamin C', 'Potassium', true),
  ('Pork Chops', 1, 242.0, '14.0g', '0.0g', '27.0g', 'Vitamin B6, Vitamin B12', 'Iron, Zinc', true),
  ('Oats', 5, 389.0, '6.9g', '66.3g', '16.9g', 'Thiamin, Riboflavin', 'Iron, Magnesium', False),
  ('Cranberries', 3, 46.0, '0.1g', '12.2g', '0.4g', 'Vitamin C', 'Manganese', true),
  ('Ginger', 9, 80.0, '0.8g', '17.8g', '1.8g', 'Vitamin C', 'Potassium, Magnesium', true),
  ('Tuna Steak', 2, 144.0, '0.5g', '0.0g', '31.0g', 'Vitamin D', 'Selenium, Magnesium', true),
  ('Spinach', 3,  23.0, '0.4g', '3.6g', '2.9g', 'Vitamin A, Vitamin K', 'Iron, Calcium', true),
  ('Pumpkin Seeds', 8, 446.0, '19.4g', '10.7g', '30.2g', 'Vitamin K', 'Iron, Magnesium', true),
  ('Chia Seeds', 8, 486.0, '30.7g', '31.4g', '16.5g', 'Calcium, Vitamin C', 'Phosphorus, Magnesium', true),
  ('Tomato Sauce', 9, 32.0, '0.2g', '6.0g', '1.0g', 'Vitamin C', 'Potassium', true),
  ('Ground Chicken',  1, 143.0, '8.0g', '0.0g', '20.0g', 'Vitamin B6, Vitamin B12', 'Iron, Zinc', true),
  ('Basil', 3, 23.0, '0.6g', '2.7g', '3.2g', 'Vitamin K', 'Iron, Calcium', true),
  ('Feta Cheese', 4, 264.0, '21.0g', '4.1g', '14.2g', 'Vitamin A, Vitamin B12', 'Calcium, Phosphorus', true),
  ('Garlic', 3, 149.0, '0.5g', '33.1g', '6.4g', 'Vitamin C, Vitamin B6', 'Manganese', true),
  ('Bacon', 1, 898.0, '99.5g', '0.1g', '0.1g', 'Vitamin B12', 'Sodium', true),
  ('Parmesan Cheese', 4, 431.0, '28.4g', '3.4g', '38.4g', 'Calcium, Vitamin B12', 'Phosphorus', true),
  ('Croutons', 5, 390.0, '6.5g', '76.8g', '10.3g', 'Vitamin E, Vitamin B1', 'Iron, Zinc', true),
  ('Garlic Powder', 3, 331.0, '1.0g', '72.9g', '16.0g', 'Vitamin C, Vitamin B6', 'Manganese', true),
  ('Mozzarella Cheese', 4, 254.0, '17.0g', '2.2g', '22.2g', 'Calcium, Vitamin B12', 'Phosphorus', true),
  ('Balsamic', 9, 88.0, '0.0g', '17.0g', '0.6g', 'Vitamin C', 'Iron, Manganese', true),
  ('Coconut Milk', 8, 230.0, '24.0g', '3.4g', '2.3g', 'Vitamin C, Vitamin E', 'Calcium, Iron', true),
  ('Curry Paste', 9, 119.0, '12.0g', '4.0g', '2.0g', 'Vitamin C', 'Iron', true),
  ('Butter', 4, 717.0, '81.0g', '0.6g', '0.9g', 'Vitamin A, Vitamin E', 'Calcium, Magnesium', true),
  ('Flour', 5, 364.0, '1.2g', '76.3g', '10.3g', 'Vitamin B1, Vitamin B3', 'Iron, Zinc', true),
  ('Sugar', 9, 387.0, '0.0g', '99.5g', '0.0g', 'None', 'None', true),
  ('Salt', 9, 0.0, '0.0g', '0.0g', '0.0g', 'None', 'Sodium', true),
  ('Baking Soda', 9, 0.0, '0.0g', '0.0g', '0.0g', 'None', 'None', true),
  ('Baking Powder', 9, 53.0, '0.0g', '27.0g', '0.0g', 'None', 'None', true)
  ;


INSERT INTO recipe (cuisine_id, title, prep_time, instructions) 
VALUES
 (6, 'Avocado Toast', '10 minutes', '1. Toast the bread. 2. Mash the avocado and spread it on the toast. 3. Sprinkle salt and pepper to taste. 4. Optional toppings: sliced tomatoes, feta cheese, or a poached egg.'),
 (2, 'Chicken Stir-Fry', '25 minutes', '1. Heat oil in a pan. 2. Cook chicken until browned. 3. Add vegetables and stir-fry for a few minutes. 4. In a separate bowl, mix soy sauce, garlic, and ginger. 5. Pour the sauce over the chicken and vegetables. 6. Cook until everything is heated through.'),
 (1, 'Pasta Carbonara', '20 minutes', '1. Cook pasta according to package instructions. 2. In a separate pan, cook bacon until crispy. 3. In a bowl, whisk together eggs, grated cheese, and black pepper. 4. Drain the pasta and add it to the pan with the bacon. 5. Remove from heat and quickly stir in the egg mixture. 6. The heat from the pasta will cook the eggs and create a creamy sauce.'),
 (4, 'Greek Salad', '15 minutes', '1. In a large bowl, combine chopped lettuce, tomatoes, cucumber, red onion, and olives. 2. Crumble feta cheese on top. 3. In a separate small bowl, whisk together olive oil, lemon juice, salt, and pepper. 4. Drizzle the dressing over the salad and toss to coat.'),
 (6, 'Quinoa Salad', '30 minutes', '1. Cook quinoa according to package instructions and let it cool. 2. In a large bowl, combine cooked quinoa, diced vegetables (such as cucumber, bell peppers, and cherry tomatoes), and chopped herbs (such as parsley and mint). 3. In a separate small bowl, whisk together olive oil, lemon juice, salt, and pepper. 4. Pour the dressing over the quinoa mixture and toss to combine.'),
 (1, 'Chicken Caesar Salad', '25 minutes', '1. Season chicken breasts with salt, pepper, and garlic powder. 2. Grill or cook the chicken until cooked through. 3. Slice the chicken into strips. 4. In a large bowl, combine chopped romaine lettuce, croutons, grated Parmesan cheese, and the sliced chicken. 5. Drizzle Caesar dressing over the salad and toss to coat.'),
 (6, 'Berry Smoothie', '5 minutes', '1. In a blender, combine frozen berries, yogurt, milk, and honey. 2. Blend until smooth and creamy. 3. Add more milk if needed to reach desired consistency. 4. Pour into glasses and serve immediately.'),
 (6, 'Caprese Salad', '10 minutes', '1. Slice tomatoes and mozzarella cheese into rounds. 2. Arrange tomato and mozzarella slices on a plate. 3. Tuck fresh basil leaves between the tomato and mozzarella slices. 4. Drizzle with olive oil and balsamic glaze. 5. Sprinkle with salt and pepper to taste.'),
 (5, 'Vegetable Curry', '40 minutes', '1. Heat oil in a pan and sauté onion, garlic, and ginger until fragrant. 2. Add diced vegetables (such as carrots, bell peppers, and potatoes) and cook until slightly softened. 3. Stir in curry paste or powder and cook for a minute. 4. Pour in coconut milk and simmer until vegetables are cooked through. 5. Serve over steamed rice or with naan bread.'),
 (6, 'Banana Bread', '1 hour', '1. Preheat the oven to 350°F (175°C) and grease a loaf pan. 2. In a bowl, mash ripe bananas with a fork. 3. In a separate bowl, cream together butter and sugar. 4. Beat in eggs and vanilla extract. 5. In another bowl, whisk together flour, baking powder, baking soda, and salt. 6. Gradually add the dry ingredients to the butter mixture, alternating with the mashed bananas. 7. Pour the batter into the prepared loaf pan and bake for about 1 hour, or until a toothpick inserted into the center comes out clean. 8. Let the banana bread cool in the pan for a few minutes before transferring it to a wire rack to cool completely.');

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, amount)
VALUES
 (1, 2, '2 slices'),
 (1, 5, '1'),
 (1, 7, '2'),
 (1, 24, '1'),
 (1, 86, '50 g'),
 (2, 3, '1 big or 2 small'),
 (2, 15, '1'),
 (2, 32, '100 g'),
 (2, 33, '1'),
 (2, 60, '2 tablespoons'),
 (2, 78, '1 cm'),
 (2, 87, '1-2 cloves'),
 (3, 7, '1'),
 (3, 12, '75 g'),
 (3, 20, '200 g'),
 (3, 88, '125g'),
 (4, 5, '2'),
 (4, 15, '1'),
 (4, 18, '100 g'),
 (4, 23, '1'),
 (4, 86, '75 g'),
 (4, 60, '2 tablespoons'),
 (5, 5, '1'),
 (5, 23, '1'),
 (5, 29, '1'),
 (5, 33, '1'),
 (5, 35, '100 g'),
 (6, 3, '1 medium'),
 (6, 18, '100 g'),
 (6, 89, '50 g'),
 (6, 90, '20 g'),
 (6, 91, '1 pinch'),
 (7, 1, '200 ml'),
 (7, 10, '75 ml'),
 (7, 25, '1 tablespoon'),
 (7, 28, '100 g'),
 (8, 5, '1'),
 (8, 60, '1 tablespoon'),
 (8, 85, 'a few leaves'),
 (8, 92, '100 g'),
 (8, 93, '1 tea spoon'),
 (9, 13, '100 g'),
 (9, 14, '75 g'),
 (9, 15, '1'),
 (9, 78, '1 cm'),
 (9, 87, '3 gloves'),
 (9, 94, '1 can'),
 (9, 95, '1-3 tablespoons'),
 (10, 7, '3 medium'),
 (10, 11, '3 ripe'),
 (10, 96, '200 g'),
 (10, 97, '200 g'),
 (10, 98, '50 g'), 
 (10, 99, '1 pinch'),
 (10, 100, '1 teaspoon'),
 (10, 101, '10 g');
 
INSERT INTO user (email, password, name, surname, is_admin)
VALUES
 ('user1@example.com', SHA2('mySuperPassword1', 256), 'John', 'Doe', False),
 ('user2@example.com', SHA2('goFigurePassword2', 256), 'Jane', 'Smith', False),
 ('admin@example.com', SHA2('Supersecure3', 256), 'Peter', 'Admin', True);
 
INSERT INTO user_includes ( user_id, ingredient_id, group_id, cuisine_id)
VALUES
(1, 7, null, null),
(1, 13, null, null),
(1, null, null, 1),
(1, null, 8, null),
(2, null, 1, null);

INSERT INTO user_excludes ( user_id, ingredient_id, group_id, cuisine_id)
VALUES
(2, 7, null, null),
(2, 13, null, null),
(2, null, null, 1),
(2, null, 8, null),
(1, null, 1, null);