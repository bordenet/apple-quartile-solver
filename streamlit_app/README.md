# Apple Quartile Solver - Streamlit

Web interface for solving Apple News Quartile puzzles built with Streamlit.

## Prerequisites

- Python 3.8 or higher
- pip

## Setup

1. **Create Virtual Environment**
   ```bash
   python3 -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

2. **Install Dependencies**
   ```bash
   pip install -r requirements.txt
   ```

3. **Verify Dictionary File**
   Ensure `../prolog/wn_s.pl` exists in the parent directory.

## Run

Start the Streamlit app:
```bash
streamlit run app.py
```

The app will open in your browser at `http://localhost:8501`

## Deploy

### Streamlit Cloud
1. Push code to GitHub
2. Go to https://share.streamlit.io
3. Connect repository and deploy

### Docker
```bash
# Create Dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
EXPOSE 8501
CMD ["streamlit", "run", "app.py", "--server.port=8501"]

# Build and run
docker build -t quartile-solver .
docker run -p 8501:8501 quartile-solver
```

## Project Structure

```
streamlit_app/
├── app.py                 # Main Streamlit app
├── solver/                # Solver package
│   ├── __init__.py
│   ├── trie.py           # Trie data structure
│   ├── dictionary.py     # Dictionary loader
│   ├── solver.py         # Puzzle solver
│   └── word_generator.py # Word form generator
└── requirements.txt
```

## Features

- Interactive web interface
- Sample puzzle quick-load
- Multiple sort options
- Download results
- Real-time solving
- Responsive layout

## Performance

- Dictionary loads once (cached)
- Solves 20-tile puzzles in <1 second
- Efficient memory usage

