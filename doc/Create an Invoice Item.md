## Create an Invoice Item

### Objectives 
This use case describes the creation of an Invoice Item

### Preconditions
The administrator must be logged in

### Postconditions
An Invoice Item is created

### Flow of Events

### Basic Flow

1. The system receives the information for the Invoice items
3. The system creates an Invoice Item with some of its fields filled up with the received information
   - Invoice - filled with Invoice lookup
   - Product - filled with the code of the informed product
4. The system calls the use case [Invoice Roll up calculations](?name=UC-PRP-0001)
5. Enf of flow

### Alternative Flows

##### 1. The administrator edits the fields Unit Price, Quantity or Total Price of the invoice item (step 1 of the basic flow)
   1. The system verifies that the status of the corresponding Invoice is set to Draft
   2. The administrator edits one or more of the following fields: Unit Price, Quantity or Total Price
   3. The administrator presses the Save button
   4. Back to step 3 of the basic flow
