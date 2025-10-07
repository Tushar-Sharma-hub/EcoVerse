#!/bin/bash

echo "🚀 Starting EcoVerse Development Environment..."

# Kill any existing processes
echo "🧹 Cleaning up existing processes..."
pkill -f "server-minimal.js" 2>/dev/null
pkill -f "react-scripts start" 2>/dev/null

# Wait for ports to be freed
sleep 2

echo "🔧 Starting backend server on port 5001..."
cd backend && npm start &
BACKEND_PID=$!

# Wait for backend to start
sleep 5

echo "⚛️  Starting frontend server on port 3000..."
cd ../frontend && npm start &
FRONTEND_PID=$!

# Wait for frontend to start
sleep 10

echo "🧪 Testing connectivity..."

# Test backend health
BACKEND_STATUS=$(curl -s http://localhost:5001/api/health 2>/dev/null | grep -o '"status":"OK"')
if [ "$BACKEND_STATUS" == '"status":"OK"' ]; then
    echo "✅ Backend is running correctly on http://localhost:5001"
else
    echo "❌ Backend health check failed"
fi

# Test frontend
FRONTEND_STATUS=$(curl -s http://localhost:3000/ 2>/dev/null | grep -o 'DOCTYPE html')
if [ "$FRONTEND_STATUS" == "DOCTYPE html" ]; then
    echo "✅ Frontend is running correctly on http://localhost:3000"
else
    echo "❌ Frontend health check failed"
fi

echo ""
echo "🌟 EcoVerse is now running!"
echo "Frontend: http://localhost:3000"
echo "Backend API: http://localhost:5001"
echo ""
echo "Press Ctrl+C to stop both services..."

# Handle Ctrl+C to kill both processes
trap 'kill $BACKEND_PID $FRONTEND_PID 2>/dev/null; exit' INT

# Keep script running
wait