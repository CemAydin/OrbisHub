# OrbisHub - Başlangıç Rehberi

Bu rehber, OrbisHub agentic AI platformunun kurulumu ve kullanımı hakkında temel bilgileri içermektedir.

## İçindekiler

1. [Proje Yapısı](#proje-yapısı)
2. [Kurulum](#kurulum)
3. [Proje Bileşenleri](#proje-bileşenleri)
4. [Agent Geliştirme](#agent-geliştirme)
5. [Dağıtım](#dağıtım)

## Proje Yapısı

OrbisHub projesi aşağıdaki ana bileşenlerden oluşmaktadır:

```
orbis-hub/
├── backend/           # API ve core servisler
├── frontend/          # Kullanıcı arayüzü
├── agents/            # Hazır agent şablonları ve örnekler
├── sdk/               # Agent geliştirme SDK'sı
├── examples/          # Örnek agent uygulamaları
├── infra/             # Altyapı konfigürasyonları (Docker, Kubernetes)
├── docker-compose.yml # Geliştirme ortamı Docker yapılandırması
├── README.md          # Proje hakkında genel bilgiler
└── start.sh           # Başlatma script'i
```

## Kurulum

Geliştirme ortamını kurmak için aşağıdaki adımları izleyin:

1. Depoyu klonlayın:
   ```
   git clone https://github.com/CemAydin/OrbisHub.git
   cd OrbisHub
   ```

2. Gerekli bağımlılıkları yükleyin:
   ```
   # Backend için
   cd backend
   npm install
   
   # Frontend için
   cd ../frontend
   npm install
   
   # SDK için
   cd ../sdk
   npm install
   npm run build
   ```

3. Veritabanı ve diğer servisler için Docker başlatın:
   ```
   cd ..
   docker-compose up -d
   ```

4. Uygulamayı başlatın:
   ```
   # Geliştirme modu için
   ./start.sh dev
   
   # veya
   
   # Üretim modu için
   ./start.sh prod
   ```

5. Tarayıcınızda aşağıdaki URL'yi açın:
   ```
   http://localhost:3000
   ```

## Proje Bileşenleri

### Backend

Backend, Node.js ve Express kullanılarak geliştirilmiş bir API sunucusudur. Bu API, agent yönetimi, görev dağıtımı ve kullanıcı arayüzüyle iletişim için gereken tüm endpoint'leri sağlar.

Temel endpoint'ler:

- `GET /api/agents` - Tüm agent'ları listeler
- `GET /api/agents/:id` - Belirli bir agent'ın bilgilerini getirir
- `POST /api/agents/:id/task` - Agent'a bir görev gönderir

### Frontend

Frontend, React ve Material-UI kullanılarak geliştirilmiş modern bir web arayüzüdür. Bu arayüz, agent'ları izlemek ve yönetmek için kullanılan bir kontrol paneli sunar.

### SDK

Agent geliştirme için TypeScript ile yazılmış bir SDK. Bu SDK, agent'ların OrbisHub platformuyla iletişim kurmasını ve görevleri işlemesini sağlar.

Örnek kullanım:

```javascript
const { OrbisAgent } = require('orbis-hub-sdk');

// Agent oluştur
const agent = new OrbisAgent({
  name: 'Test Agent',
  capabilities: ['test']
});

// Görev işleyici kaydet
agent.registerTaskHandler('test', async (task, context) => {
  return { message: 'Test başarılı!' };
});

// Agent'ı başlat
agent.start();
```

## Agent Geliştirme

OrbisHub platformu için özel agent'lar geliştirmek için aşağıdaki adımları izleyin:

1. SDK'yı kurun:
   ```
   npm install orbis-hub-sdk
   ```

2. Yeni bir agent projesi oluşturun:
   ```
   mkdir my-agent
   cd my-agent
   npm init -y
   ```

3. Agent kodunu geliştirin (örnek `index.js`):
   ```javascript
   const { OrbisAgent } = require('orbis-hub-sdk');
   
   const agent = new OrbisAgent({
     name: 'My Custom Agent',
     description: 'Özel görevleri yerine getiren agent',
     capabilities: ['custom-task'],
     backendUrl: 'http://localhost:8000',
     autoRegister: true
   });
   
   agent.registerTaskHandler('custom-task', async (task, context) => {
     // Görev işleme mantığı
     return { result: 'İşlem tamamlandı' };
   });
   
   agent.start()
     .then(() => console.log('Agent başlatıldı'))
     .catch(err => console.error('Hata:', err));
   ```

4. Agent'ı başlatın:
   ```
   node index.js
   ```

## Dağıtım

OrbisHub platformu hem on-premises hem de cloud ortamlarında çalışabilir.

### Kubernetes ile Dağıtım

Kubernetes ile dağıtım için `infra/kubernetes` dizinindeki yapılandırma dosyalarını kullanabilirsiniz:

```
kubectl apply -k infra/kubernetes
```

### Docker ile Dağıtım

Docker ile dağıtım için:

```
docker-compose -f docker-compose.prod.yml up -d
```

---

Daha fazla bilgi için [resmi dokümantasyonu](https://docs.orbislabs.ai) ziyaret edin veya [destek ekibimizle](mailto:support@orbislabs.ai) iletişime geçin.