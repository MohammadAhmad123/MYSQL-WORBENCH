-- Create a new database named LibraryDB
CREATE DATABASE LibraryDB;

-- Use the LibraryDB database for all subsequent operations
USE LibraryDB;

show tables;

-- Create the Books table to store information about each book in the library
CREATE TABLE Books (
    book_id INT PRIMARY KEY AUTO_INCREMENT, -- Primary Key: unique identifier for each book
    title VARCHAR(255) NOT NULL, -- Title of the book
    author VARCHAR(255) NOT NULL, -- Author of the book
    genre VARCHAR(100), -- Genre of the book
    published_year YEAR  -- Year the book was published
);

-- Create the Borrowers table to store information about each library borrower
CREATE TABLE Borrowers (
    borrower_id INT PRIMARY KEY AUTO_INCREMENT, -- Primary Key: unique identifier for each borrower
    name VARCHAR(255) NOT NULL, -- Name of the borrower 
    email VARCHAR(255) NOT NULL, -- Email address of the borrower
    phone_number VARCHAR(15) -- Phone number of the borrower
);

-- Create the BorrowedBooks table to track books that have been borrowed
CREATE TABLE BorrowedBooks (
    borrowed_id INT PRIMARY KEY AUTO_INCREMENT, -- Primary Key: unique identifier for each borrowing record
    book_id INT, -- Foreign Key referencing the Books table (book that was borrowed)
    borrower_id INT, -- Foreign Key referencing the Borrowers table (who borrowed the book)
    borrow_date DATE, -- Date when the book was borrowed
    return_date DATE, -- Date when the book was returned (NULL if not yet returned)
    
    -- Set up Foreign Key constraints to ensure data integrity
    FOREIGN KEY (book_id) REFERENCES Books(book_id), -- Links to the book's unique identifier in the Books table
    FOREIGN KEY (borrower_id) REFERENCES Borrowers(borrower_id) -- Links to the borrower's unique identifier in the Borrowers table
);

select * from Books;
select * from Borrowers;
select * from BorrowedBooks;


-- Insert sample data into Books table
INSERT INTO Books (title, author, genre, published_year) VALUES
('Reverend Insanity', 'Gu Zhen Re', 'fantasy', 2012),  -- Add a book record with title, author, genre, and year
('The Return of the Disaster-Class Hero', 'SAN.G (산지직송)', 'action and fantasy', 2021),  -- Add another book record
('Second Life Ranker', 'Sadoyeon (사도연)', 'action and fantasy', 2021); -- Add a third book record


-- Insert sample data into Borrowers table
INSERT INTO Borrowers (name, email, phone_number) VALUES
('Alamin Ahmad', 'alamin@example.com', '123-456-7890'), -- Add a borrower with name, email, and phone number
('Jason Lee', 'jason@example.com', '987-654-3210');  -- Add another borrower

-- Insert sample data into BorrowedBooks table
INSERT INTO BorrowedBooks (book_id, borrower_id, borrow_date, return_date) VALUES
(1, 1, '2024-11-01', NULL), -- Record a book borrowed by Alice with no return date (still borrowed)
(2, 2, '2024-11-02', '2024-11-10'); -- Record a book borrowed and returned by Bob


























