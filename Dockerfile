# Use an official Python runtime as the base image
FROM python:3.12-slim

# Environment variables to optimize Python behavior inside Docker
ENV PYTHONDONTWRITEBYTECODE=1 \   # Prevents Python from writing .pyc files to disk
    PYTHONUNBUFFERED=1 \          # Ensures logs are shown in real time (no buffering)
    PIP_DISABLE_PIP_VERSION_CHECK=1 \  # Disables pip update checks
    PIP_NO_CACHE_DIR=1                 # Prevents pip from caching packages to save space

# Set the working directory in the container
WORKDIR /app

# Install system dependencies that are often required to build Python packages (like psycopg2)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy only the requirements file first to leverage Docker layer caching
COPY requirements.txt ./

# Upgrade pip and install Python dependencies
RUN python -m pip install --upgrade pip && \
    pip install -r requirements.txt

# Copy the rest of the project files into the container
COPY . .

# Expose the port Django will run on (default: 8000)
EXPOSE 8000

# Default command: run migrations and start the Django development server
CMD ["sh", "-c", "python manage.py migrate && python manage.py runserver 0.0.0.0:8000"]
