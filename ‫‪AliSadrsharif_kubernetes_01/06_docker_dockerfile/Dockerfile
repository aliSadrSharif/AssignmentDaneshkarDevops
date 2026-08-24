# Use a small Python base image (Alpine variant keeps the final image small)
FROM python:3.11-alpine

# Set the working directory inside the container; subsequent COPY/CMD use this as base
WORKDIR /app

# Copy only the server script into the image (kept minimal via .dockerignore)
COPY app/server.py .

# Document that the container listens on port 8000 (informational; doesn't publish it)
EXPOSE 8000

# Default command executed when the container starts
CMD ["python", "server.py"]
