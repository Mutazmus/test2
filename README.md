# 📦 XView – Excel Product Viewer

**XView** is a Flutter-based desktop/mobile app that allows users to import product data from Excel files (`.xlsx`) and view it in a structured table format.  
It's ideal for inventory managers, store owners, or anyone who works with product data stored in spreadsheets.

---

## 🚀 Features

- 📂 Upload `.xlsx` Excel files from local storage
- 📊 Display product data in a scrollable table (DataTable)
- 🖼️ Show product image from online URLs
- 📝 Includes product name, description (EN/AR), price (AED), barcode, and quantity
- 🔄 Easy refresh by uploading a new file
- 🧑‍💻 Built with clean Flutter UI

---

## 📁 Expected Excel Format

The Excel file should follow this column order (starting from Column A):

| Column | Field                     |
|--------|---------------------------|
| A      | Photo URL (for product)   |
| B      | Price (AED)               |
| C      | Description (EN)          |
| D      | Description (AR)          |
| E      | Product Name (AR)         |
| F      | Product Name (EN)         |
| G      | Barcode                   |
| H      | Quantity                  |

---

## 📸 App Preview

> *(Add screenshot if available)*  
> ![Screenshot](screenshots/app_ui.png)

---

## 🧪 How to Run

```bash
# 1. Clone the repository
git clone https://github.com/yourusername/xview.git

# 2. Navigate to the project
cd xview

# 3. Install dependencies
flutter pub get

# 4. Run the app (desktop or mobile)
flutter run
