## Create Backend Invoice Page

### Objectives
The present use case describes how the system creates an Invoice through the backend page

### Preconditions
The administrator must be logged in

### Postconditions
The Invoice was created

### Flow of Events

### Basic Flow
1. The administrator goes to the Invoices tab
2. The system shows the Invoices landing page
3. The administrator selects a Program that requests invoice products
4. The administrator presses the New button
5. The system displays the New Invoice page
6. The system displays the fieldset defined for the New Invoice page, with its fields blank
7. The system displays the Items area, containing:
   - Add Products button to search products in advanced mode
   - New button to insert a new item line
   - Item lines to insert products information with the fields Quantity, Product, Unit Price and Total price.
   - For each item line, a corresponding Remove icon
   - Amount field that summarizes the Total Price of all inserted products
8. The system displays the option to upload an image for the Invoice
9. The system displays the Save and Cancel buttons 
10. The administrator fills the invoice fields
11. The administrator starts typing in the product field
12. The system displays the products that match the typed text
13. The administrator selects the product
14. The administrator fills the quantity and price fields
15. The administrator presses the New button
16. The system displays a new item line
17. The administrator selects the product
18. The administrator fills the quantity and price fields
19. The administrator uploads the image
20. The administrator presses the Save button 
21. The system calls the Use Case [Create Invoice](?name=UC-PRP-0002)
22. The system displays the Invoice detail page
23. End of flow

### Alternative Flows

##### 1. The administrator selects a Program that does not consider invoice items (step 3 of basic flow)
   1. The administrator presses the New button
   2. The system displays the New Invoice page
   3. The system displays the header fieldset of the Invoice, with its fields blank
   4. The system displays the option to upload an image for the Invoice
   5. The system displays the buttons Save and Cancel
   6. The administrator fills the invoice header fields
   7. The administrator uploads the image
   8. The administrator presses the Save button
   9. The system calls the alternative flow 1 of use case [Create Invoice](?name=UC-PRP-0002)
   10. End of flow
   
##### 2. The administrator presses the Add Products button (step 8 of basic flow)
   1. The system displays the Add  products page
   2. The system displays a filter area where product fields are used to search, according to the defined fieldset
   3. The system displays a Search button
   4. The system displays a results area where the products that fit the search are listed
   5. The system displays the buttons “Add” and “Cancel”
   6. The administrator fills the filters fields
   7. The administrator presses the Search button
   8. The system lists, in the results area, the products that fit the search
   9. The system shows, for each line of product, its data disposed in columns defined by the fieldset and a checkbox to select the product 
   10. The administrator selects one or more products in the results area by marking their checkboxes
   11. The administrator presses the Add button
   12. The system returns to New Invoice page where all the products selected are shown in one or more lines
   13. The administrator fills quantities and prices (fieldset defined) for the selected items
   14. Back to step 9 of basic flow
   
##### 3. The administrator deletes an item (step 18 of basic flow)
   1. The administrator presses the delete button beside an item line
   2. The system removes the line from the list of selected items
   3. Back to step 17 of basic flow
   
##### 4. The administrator cancels the invoice creation (step 20 of basic flow and step 8 of alternative flow 1)
   1. The administrator presses the button Cancel
   2. The system ignores all the inputted values and does not create the invoice
   3. The system returns to the Invoices landing page where no new invoice is listed
   4. End of flow

##### 5. The administrator edits a Draft Invoice with details (step 4 of basic flow)
   1. The administrator selects one invoice in the landing page which status is Draft
   2. The system displays the Invoice details page
   3. The administrator presses the Edit button
   4. The system displays the Edit Invoice page
   5. The system displays the header fieldset of the Invoice, with its fields already filled with the invoice data
   6. The system displays a button to include a New item
   7. The system displays a button to Add Products in advanced mode
   8. The system displays the list of products for the invoice with their fieldset already filled
   9. The system displays the uploaded image for the Invoice
   10. The system displays the buttons Cancel and Save
   11. The administrator makes the desired changes
   12. The administrator presses the button Save
   13. The system calls the basic flow of use case [Create Invoice](?name=UC-PRP-0002)
   14. The system returns to the Invoice Details Page

##### 6. The administrator edits a Draft Invoice without details (step 1 of alternative flow 1)
   1. The administrator selects one invoice in the landing page which status is Draft
   2. The system displays the Invoice details page
   3. The administrator presses the Edit button
   4. The system displays the Edit Invoice page
   5. The system displays the header fieldset of the Invoice, with its fields already filled with the invoice data
   6. The system displays the uploaded image for the Invoice
   7. The system displays the buttons Cancel and Save
   8. The administrator makes the desired changes
   9. The administrator presses the button Save
   10. The system calls the alternative flow 1 of use case [Create Invoice](?name=UC-PRP-0002)
   11. The system returns to the Invoice Details Page
