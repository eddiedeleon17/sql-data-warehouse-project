# Data Warehouse y Analytics con SQL Server

Proyecto de portafolio que construye un data warehouse completo desde cero: ingesta de datos crudos, limpieza, modelado en esquema estrella y análisis SQL para responder preguntas de negocio.

---

## 🏗️ Arquitectura

El proyecto sigue la **arquitectura Medallion** con tres capas:
<img width="1544" height="912" alt="data_architecture" src="https://github.com/user-attachments/assets/ba420eab-5609-4442-a70b-975fcbc1f45e" />

## 📖 Qué incluye el proyecto

1. **Arquitectura de datos:** diseño del warehouse en capas Bronze, Silver y Gold.
2. **Pipelines ETL:** extracción, transformación y carga desde los sistemas fuente mediante stored procedures.
3. **Modelado de datos:** tablas de hechos y dimensiones optimizadas para consultas analíticas.
4. **Analytics y reporting:** reportes en SQL sobre comportamiento de clientes, desempeño de productos y tendencias de ventas.

**Habilidades que demuestra:** SQL Development · Data Engineering · ETL · Data Modeling · Data Analytics

---

## 🛠️ Herramientas

- **SQL Server Express** — motor de base de datos
- **SQL Server Management Studio (SSMS)** — gestión y consultas
- **DrawIO** — diagramas de arquitectura y modelos
- **Git / GitHub** — control de versiones

---

## 🚀 Requerimientos

### Data Engineering

**Objetivo:** desarrollar un data warehouse en SQL Server que consolide datos de ventas para habilitar reportes analíticos.

- **Fuentes:** dos sistemas (ERP y CRM) entregados como archivos CSV.
- **Calidad de datos:** limpiar y resolver problemas de calidad antes del análisis.
- **Integración:** unificar ambas fuentes en un solo modelo optimizado para consultas.
- **Alcance:** solo el dataset más reciente; no se requiere historización.
- **Documentación:** documentar el modelo para stakeholders de negocio y equipos de analytics.

### Analytics y Reporting

**Objetivo:** desarrollar análisis en SQL que entreguen insights sobre:

- Comportamiento de clientes
- Desempeño de productos
- Tendencias de ventas

Detalle completo en [docs/requirements.md](docs/requirements.md).

---

## 📂 Estructura del repositorio

data-warehouse-project/
│
├── datasets/                           # Raw datasets used for the project (ERP and CRM data)
│
├── docs/                               # Project documentation and architecture details
│   ├── etl.drawio                      # Draw.io file shows all different techniquies and methods of ETL
│   ├── data_architecture.drawio        # Draw.io file shows the project's architecture
│   ├── data_catalog.md                 # Catalog of datasets, including field descriptions and metadata
│   ├── data_flow.drawio                # Draw.io file for the data flow diagram
│   ├── data_models.drawio              # Draw.io file for data models (star schema)
│   ├── naming-conventions.md           # Consistent naming guidelines for tables, columns, and files
│
├── scripts/                            # SQL scripts for ETL and transformations
│   ├── bronze/                         # Scripts for extracting and loading raw data
│   ├── silver/                         # Scripts for cleaning and transforming data
│   ├── gold/                           # Scripts for creating analytical models
│
├── tests/                              # Test scripts and quality files
│
├── README.md                           # Project overview and instructions
├── LICENSE                             # License information for the repository
├── .gitignore                          # Files and directories to be ignored by Git
└── requirements.txt                    # Dependencies and requirements for the project


---

## 🛡️ Licencia

Este proyecto está bajo la [Licencia MIT](LICENSE). Libre de usar, modificar y compartir con la atribución correspondiente.

---

## 🌟 Sobre mí

Soy **Eddie de León**, licenciado en Economía y en Marketing por la Universidad Rafael Landívar (Guatemala), con formación en econometría y herramientas de análisis de datos (SQL, Python, Excel, Power BI). Actualmente construyo proyectos de datos enfocados en convertir información en decisiones de negocio.

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](TU_LINK_DE_LINKEDIN)
[![Gmail](https://img.shields.io/badge/Email-D14836?style=for-the-badge&logo=gmail&logoColor=white)](mailto:eddie.deleon17@gmail.com)

---

> Proyecto basado en el curso de Data Warehouse de [Data With Baraa](https://www.datawithbaraa.com).

