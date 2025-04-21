#!/bin/bash

# OrbisHub Başlatma Script'i

# Renkli çıktı fonksiyonları
print_green() {
  echo -e "\033[0;32m$1\033[0m"
}

print_blue() {
  echo -e "\033[0;34m$1\033[0m"
}

print_red() {
  echo -e "\033[0;31m$1\033[0m"
}

print_yellow() {
  echo -e "\033[0;33m$1\033[0m"
}

print_blue "=============================================" 
print_blue "            OrbisHub Başlatılıyor            "
print_blue "=============================================" 
echo ""

# Çalıştırma modunu belirle
MODE=${1:-"dev"}

if [ "$MODE" == "dev" ]; then
  print_green "Geliştirme modunda başlatılıyor..."
elif [ "$MODE" == "prod" ]; then
  print_yellow "Üretim modunda başlatılıyor..."
else
  print_red "Bilinmeyen mod: $MODE"
  print_red "Kullanım: ./start.sh [dev|prod]"
  exit 1
fi

echo ""

# Dizin yolu kontrolü
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

print_blue "Bağımlılıkları yükleniyor..."

# Backend bağımlılıklarını yükle
cd "$SCRIPT_DIR/backend"
npm install
if [ $? -ne 0 ]; then
  print_red "Backend bağımlılıkları yüklenirken hata oluştu."
  exit 1
fi

# Frontend bağımlılıklarını yükle
cd "$SCRIPT_DIR/frontend"
npm install
if [ $? -ne 0 ]; then
  print_red "Frontend bağımlılıkları yüklenirken hata oluştu."
  exit 1
fi

# SDK bağımlılıklarını yükle ve derle
cd "$SCRIPT_DIR/sdk"
npm install
npm run build
if [ $? -ne 0 ]; then
  print_red "SDK bağımlılıkları yüklenirken hata oluştu."
  exit 1
fi

cd "$SCRIPT_DIR"
echo ""
print_green "Tüm bağımlılıklar başarıyla yüklendi."
echo ""

# Docker kontrolü
if command -v docker &> /dev/null && command -v docker-compose &> /dev/null; then
  print_blue "Docker bileşenleri başlatılıyor..."
  docker-compose up -d
  if [ $? -ne 0 ]; then
    print_red "Docker bileşenleri başlatılırken hata oluştu."
    exit 1
  fi
else
  print_yellow "Docker veya docker-compose bulunamadı. Docker bileşenleri atlanıyor."
fi

echo ""

# Backend ve Frontend'i başlat
if [ "$MODE" == "dev" ]; then
  # Geliştirme modunda
  print_blue "Backend ve Frontend geliştirme modunda başlatılıyor..."
  
  # Yeni terminal pencereleri aç
  if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    osascript -e 'tell app "Terminal" to do script "cd \"'"$SCRIPT_DIR"'/backend\" && npm run dev"'
    osascript -e 'tell app "Terminal" to do script "cd \"'"$SCRIPT_DIR"'/frontend\" && npm start"'
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    if command -v gnome-terminal &> /dev/null; then
      gnome-terminal -- bash -c "cd '$SCRIPT_DIR/backend' && npm run dev; bash"
      gnome-terminal -- bash -c "cd '$SCRIPT_DIR/frontend' && npm start; bash"
    elif command -v xterm &> /dev/null; then
      xterm -e "cd '$SCRIPT_DIR/backend' && npm run dev" &
      xterm -e "cd '$SCRIPT_DIR/frontend' && npm start" &
    else
      print_red "Terminal emülatörü bulunamadı. Manuel olarak başlatın:"
      print_yellow "Terminal 1: cd $SCRIPT_DIR/backend && npm run dev"
      print_yellow "Terminal 2: cd $SCRIPT_DIR/frontend && npm start"
    fi
  else
    print_red "İşletim sisteminiz algılanamadı. Manuel olarak başlatın:"
    print_yellow "Terminal 1: cd $SCRIPT_DIR/backend && npm run dev"
    print_yellow "Terminal 2: cd $SCRIPT_DIR/frontend && npm start"
  fi
else
  # Üretim modunda
  print_blue "Backend ve Frontend üretim modunda başlatılıyor..."
  
  cd "$SCRIPT_DIR/backend"
  NODE_ENV=production npm start &
  BACKEND_PID=$!
  
  cd "$SCRIPT_DIR/frontend"
  npm run build
  if [ $? -ne 0 ]; then
    print_red "Frontend build hatası."
    kill $BACKEND_PID
    exit 1
  fi
  
  # Basit bir HTTP sunucusu ile frontend'i servis et
  cd build
  if command -v npx &> /dev/null; then
    npx serve -s &
    FRONTEND_PID=$!
  else
    print_yellow "npx bulunamadı. Frontend için HTTP sunucusu başlatılamadı."
  fi
  
  cd "$SCRIPT_DIR"
  
  print_green "Backend ve Frontend başlatıldı."
  print_yellow "Kapatmak için CTRL+C tuşlarına basın."
  
  # Çıkış sinyallerini yakala
  trap "kill $BACKEND_PID; kill $FRONTEND_PID 2>/dev/null; print_red 'Kapatılıyor...'; exit 0" SIGINT SIGTERM
  
  # Ana sürecin beklemesi
  wait
fi

echo ""
print_green "OrbisHub başlatıldı!"
print_blue "Backend: http://localhost:8000"
print_blue "Frontend: http://localhost:3000"
echo ""
print_yellow "Uygulamayı kullanmak için tarayıcınızda http://localhost:3000 adresini açın."
echo ""
print_blue "=============================================="