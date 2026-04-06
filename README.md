# 💊 PharmaTrack
> A prescription and inventory management system for independent pharmacies.  
> Built with MySQL — Database Systems Project, Spring 2025.

---

## 📁 Project Structure

```
pharmatrack/
├── 01_create_schema.sql                # Creates all tables and constraints
├── 02_insert_data.sql                  # Inserts sample data
├── 03_queries.sql                      # Demo queries
├── 04_triggers_procedure_function.sql  # Triggers, stored procedure, function
└── README.md
```

---

## ⚙️ Setup — Install MySQL

<details>
<summary><strong>🍎 Mac</strong></summary>

**Option A — Homebrew (recommended):**
```bash
brew install mysql
brew services start mysql
```

**Option B — Installer:**  
Download from https://dev.mysql.com/downloads/mysql/

</details>

<details>
<summary><strong>🪟 Windows</strong></summary>

Download and run the MySQL Installer:  
https://dev.mysql.com/downloads/installer/

> ⚠️ If your terminal says `mysql` is not recognized after installing, you need to add MySQL to your PATH.  
> Default location: `C:\Program Files\MySQL\MySQL Server 8.0\bin`  
> Add that path to your system Environment Variables, then restart your terminal.

</details>

<details>
<summary><strong>🐧 Linux (Ubuntu/Debian)</strong></summary>

```bash
sudo apt update
sudo apt install mysql-server
sudo systemctl start mysql
```

</details>

---

## 🗄️ Loading the Database

### Option A — MySQL Workbench
1. Open MySQL Workbench and connect to your local server
2. Go to `File > Open SQL Script`
3. Open `01_create_schema.sql` → click the ⚡ button to run
4. Open `02_insert_data.sql` → click the ⚡ button to run
5. Verify with `SELECT * FROM DOCTOR;` in a new query tab

---

### Option B — Terminal / CLI

**Step 1 — Log into MySQL**

| Platform | Command |
|---|---|
| Mac / Linux | `mysql -u root -p` |
| Windows (Git Bash or CMD) | `mysql -u root -p` |

**Step 2 — Run the SQL files**

Replace `/path/to/pharmatrack/` with the actual path to your cloned repo folder.

| Platform | Example path |
|---|---|
| Mac | `/Users/YourName/pharmatrack/` |
| Windows | `C:/Users/YourName/pharmatrack/` |
| Linux | `/home/YourName/pharmatrack/` |

> ⚠️ On Windows, use forward slashes `/` inside the MySQL shell, not backslashes.

```sql
SOURCE /path/to/pharmatrack/01_create_schema.sql;
USE pharmatrack;
SOURCE /path/to/pharmatrack/02_insert_data.sql;
```

**Step 3 — Verify**
```sql
SELECT * FROM DOCTOR;
SELECT * FROM PATIENT;
SELECT * FROM MEDICATION;
```

---

## 🔄 Resetting the Database

If you need to start fresh, just re-run the schema file — it drops and recreates everything automatically.

```sql
SOURCE /path/to/pharmatrack/01_create_schema.sql;
USE pharmatrack;
SOURCE /path/to/pharmatrack/02_insert_data.sql;
```

---

## 🛠️ Useful MySQL Commands

| Command | Description |
|---|---|
| `SHOW DATABASES;` | List all databases |
| `USE pharmatrack;` | Switch to PharmaTrack database |
| `SHOW TABLES;` | List all tables |
| `DESCRIBE DOCTOR;` | Show columns and types for a table |
| `SELECT * FROM DOCTOR;` | View all rows in a table |
| `EXIT;` | Exit MySQL |

---

## 🤝 Git Workflow

Since you know the basics, here's the flow we're using:

```bash
# Before you start working
git pull origin main

# After making changes
git add .
git commit -m "Brief description of what you changed"
git push origin main
```

> **Tip:** Keep commit messages specific — `"Add triggers to 04 file"` is better than `"updated stuff"`

### Handling Merge Conflicts
If two people edited the same file, Git will flag it. Open the file, look for the `<<<<<<<` markers, resolve it manually, then:

```bash
git add .
git commit -m "Resolve merge conflict"
git push origin main
```
---

## 📝 Notes

- Always run `01_create_schema.sql` **before** `02_insert_data.sql`
- If the schema changes, everyone needs to re-run `01_create_schema.sql` to stay in sync
- Never commit your MySQL password anywhere in the repo
