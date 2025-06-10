# NetOnNet-ecommerce-database
A realistic e-commerce database design for NetOnNet, featuring a relational schema, star schema, and snowflake schema. Includes ER diagrams, SQL scripts with sample data, and a documented agile development process based on user stories.

---

## 📌 Overview

This project is a realistic e-commerce database implementation for **NetOnNet**, designed from scratch for an e-commerce system. It covers the full design lifecycle:

- Relational schema (3NF with data integrity and cardinality)
- Star schema for BI use cases
- Snowflake schema for advanced analytics
- Agile development process driven by user stories and MoSCoW prioritization

---

## 🧠 Project Contents

```
📁 docs/
│   ├── ERD_Conceptual.png                # Conceptual ER diagram
│   ├── ERD_Logical.png                   # Logical ER diagram (relations, cardinality, attributes)
│   ├── ERD_Snowflake.png                 # Snowflake schema diagram for BI/analytics
│   ├── NetOnNet_Project_Methodology_EN.docx  # Agile methodology, sprint structure & roles
│   └── NetOnNet_Gantt_Cleaned.png        # Project timeline (Gantt chart)
📁 scripts/
│   ├── relational_schema.sql             # SQL script for creating relational DB & sample data
│   ├── star_schema.sql                   # Script to build star schema structure & data
│   └── snowflake_schema.sql              # Script to extend star schema to snowflake
📄 README.md                              # This file
```

---

## 🎯 Highlights

- **Data integrity & normalization**: Relational schema designed to 3NF, with enforced primary/foreign keys and correct cardinality.
- **Schema evolution**:
  - Relational database—ideal for OLTP.
  - Star schema—optimizes analytical queries.
  - Snowflake schema—adds normalized dimension tables.
- **Agile process**:
  - Requirements gathered via **user stories**
  - Prioritized using **MoSCoW**
  - Implemented in 1-week sprints
  - Collaborative roles based on functional domains
- **Documentation included**:
  - ER diagrams (conceptual, logical, snowflake)
  - Gantt chart for timeline
  - Project methodology document

---

## 📁 Documentation

All design artifacts and planning materials are located in the `docs/` directory:

- **ERD diagrams**: conceptual → logical → snowflake
- **Methodology doc**: outlines agile structure and collaborative workflow
- **Project timeline**: Gantt chart showing sprint progress and task distribution

---

## 🤝 Who Should Use This?

- Students learning database design and modeling  
- Developers building BI or analytics-ready data warehouses  
- Teams adopting agile methods in data architecture

---

## 🔮 Future Enhancements

- Add **fact and dimension tables** with surrogate keys and date dimensions
- Implement **views or stored procedures** for common BI queries
- Add **performance testing schema** to showcase difference between star and snowflake queries

---

