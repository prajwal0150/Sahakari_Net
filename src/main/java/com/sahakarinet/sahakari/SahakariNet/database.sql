use sahakarinet;


-- 1. USERS
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('ADMIN','STAFF','MEMBER') NOT NULL DEFAULT 'MEMBER',
    is_active BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_username (username),
    INDEX idx_email (email),
    INDEX idx_role (role)
);

-- 2. MEMBERS
CREATE TABLE members (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    full_name VARCHAR(100) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender VARCHAR(20) NOT NULL,
    phone VARCHAR(15) NOT NULL,
    address VARCHAR(255) NOT NULL,
    citizenship_no VARCHAR(30) NOT NULL UNIQUE,
    status ENUM('PENDING','APPROVED','REJECTED') NOT NULL DEFAULT 'PENDING',
    joined_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,

    INDEX idx_status (status),
    INDEX idx_citizenship (citizenship_no),
    INDEX idx_phone (phone),
    INDEX idx_full_name (full_name)
);

-- 3. STAFF
CREATE TABLE staff_profiles (
    user_id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    gender VARCHAR(20) NOT NULL,
    phone VARCHAR(15) NOT NULL,
    permanent_address VARCHAR(255) NOT NULL,
    temporary_address VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 4. SAVINGS ACCOUNTS
CREATE TABLE savings_accounts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT NOT NULL UNIQUE,
    balance DECIMAL(15,2) NOT NULL DEFAULT 0.00,
    share_capital DECIMAL(15,2) NOT NULL DEFAULT 1000.00,
    interest_rate DECIMAL(5,2) NOT NULL DEFAULT 6.00,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (member_id) REFERENCES members(id) ON DELETE CASCADE
);

-- 5. LOANS (CREATE BEFORE TRANSACTIONS)
CREATE TABLE loans (
    id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT NOT NULL,
    amount DECIMAL(15,2) NOT NULL CHECK (amount > 0),
    purpose VARCHAR(255) NOT NULL,
    status ENUM('PENDING','APPROVED','REJECTED','DISBURSED','CLOSED') NOT NULL DEFAULT 'PENDING',
    interest_rate DECIMAL(5,2) NOT NULL DEFAULT 12.00,
    duration_months INT NOT NULL DEFAULT 12,
    monthly_emi DECIMAL(15,2),
    applied_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    approved_date TIMESTAMP NULL,
    disbursed_date TIMESTAMP NULL,
    approved_by INT,

    FOREIGN KEY (member_id) REFERENCES members(id) ON DELETE CASCADE,
    FOREIGN KEY (approved_by) REFERENCES users(id),

    INDEX idx_member_id (member_id),
    INDEX idx_status (status)
);

-- 6. TRANSACTIONS
CREATE TABLE transactions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT NOT NULL,
    type ENUM('DEPOSIT','WITHDRAWAL','LOAN_DISBURSE','LOAN_REPAYMENT','INTEREST_CREDIT') NOT NULL,
    amount DECIMAL(15,2) NOT NULL CHECK (amount > 0),
    balance_after DECIMAL(15,2) NOT NULL,
    description VARCHAR(255),
    loan_id INT DEFAULT NULL,
    recorded_by INT NOT NULL,
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (member_id) REFERENCES members(id) ON DELETE CASCADE,
    FOREIGN KEY (loan_id) REFERENCES loans(id) ON DELETE SET NULL,
    FOREIGN KEY (recorded_by) REFERENCES users(id),

    INDEX idx_member_id (member_id),
    INDEX idx_transaction_date (transaction_date),
    INDEX idx_type (type)
);

-- 7. LOAN REPAYMENTS
CREATE TABLE loan_repayments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    loan_id INT NOT NULL,
    instalment_no INT NOT NULL,
    due_date DATE NOT NULL,
    due_amount DECIMAL(15,2) NOT NULL,
    paid_amount DECIMAL(15,2) NOT NULL DEFAULT 0.00,
    paid_date TIMESTAMP NULL,
    is_defaulted BOOLEAN NOT NULL DEFAULT FALSE,

    FOREIGN KEY (loan_id) REFERENCES loans(id) ON DELETE CASCADE,

    INDEX idx_loan_id (loan_id),
    INDEX idx_due_date (due_date),
    INDEX idx_is_defaulted (is_defaulted)
);

-- 8. CONTACT INQUIRIES
CREATE TABLE contact_inquiries (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    message TEXT NOT NULL,
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_read BOOLEAN NOT NULL DEFAULT FALSE
);