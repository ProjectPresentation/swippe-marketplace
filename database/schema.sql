-- Users (handled by Supabase Auth, but we can extend)
CREATE TABLE user_profiles (
    id UUID REFERENCES auth.users(id) PRIMARY KEY,
    email TEXT,
    name TEXT,
    phone TEXT,
    address TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Categories
CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Products
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    category_id INTEGER REFERENCES categories(category_id),
    image_url TEXT,
    stock_quantity INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Orders
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    user_id UUID REFERENCES user_profiles(id),
    total_amount DECIMAL(10,2) NOT NULL,
    status TEXT DEFAULT 'placed' CHECK (status IN ('placed', 'confirmed', 'out_for_delivery', 'delivered', 'cancelled')),
    delivery_address TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    delivered_at TIMESTAMP WITH TIME ZONE
);

-- Order Items
CREATE TABLE order_items (
    item_id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders(order_id),
    product_id INTEGER REFERENCES products(product_id),
    quantity INTEGER NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Diet Plans (NEW)
CREATE TABLE diet_plans (
    plan_id SERIAL PRIMARY KEY,
    user_id UUID REFERENCES user_profiles(id),
    week_start DATE NOT NULL,
    plan_json JSONB, -- Store weekly meal suggestions
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Suggestions (NEW)
CREATE TABLE suggestions (
    suggestion_id SERIAL PRIMARY KEY,
    user_id UUID REFERENCES user_profiles(id),
    product_id INTEGER REFERENCES products(product_id),
    reason TEXT NOT NULL, -- 'daily_repeat', 'diet_plan', 'trending'
    score DECIMAL(3,2) DEFAULT 0.5, -- Confidence score
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    expires_at TIMESTAMP WITH TIME ZONE
);

-- Indexes for performance
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_orders_user ON orders(user_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_suggestions_user ON suggestions(user_id);