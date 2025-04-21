# OrbisHub

OrbisHub, birden fazla AI ajanın yönetilebildiği ve çalıştırılabildiği, hem on-premises hem de cloud tabanlı bir agentic AI platformudur.

## Özellikler

- Birden fazla AI agentin merkezi yönetimi
- Hem on-premises hem de cloud deployment seçenekleri
- Modüler ve ölçeklenebilir mimari
- Güçlü API entegrasyonları (OpenAI, Anthropic, HuggingFace, vb.)
- Agent görev dağıtım ve orkestrasyon sistemi
- Gerçek zamanlı izleme ve analitik
- Gelişmiş güvenlik özellikleri
- Agent geliştirme için SDK

## Proje Yapısı

- `backend/`: API ve core servisler
- `frontend/`: Kullanıcı arayüzü
- `agents/`: AI ajanları ve konfigürasyonları
- `infra/`: Altyapı konfigürasyonları (Docker, Kubernetes, vb.)
- `sdk/`: Agent geliştirme SDK'sı
- `examples/`: Örnek agent uygulamaları
- `docs/`: Dokümantasyon

## Başlangıç

Detaylı kurulum talimatları için [GETTING_STARTED.md](./GETTING_STARTED.md) dosyasına bakın.

Hızlı başlangıç:

```bash
# Repoyu klonlayın
git clone https://github.com/CemAydin/OrbisHub.git
cd OrbisHub

# Bağımlılıkları yükleyin ve uygulamayı başlatın
./start.sh dev
```

## Teknoloji Yığını

OrbisHub, modern teknolojiler kullanılarak geliştirilmiştir:

- **Backend**: Node.js, Express.js, TypeScript, PostgreSQL, MongoDB, Redis
- **Frontend**: React.js, Material-UI
- **AI Entegrasyonları**: OpenAI API, Anthropic API, LangChain
- **DevOps**: Docker, Kubernetes, GitHub Actions

Detaylı teknoloji yığını için [TECH_STACK.md](./docs/TECH_STACK.md) dosyasına bakın.

## Agent Geliştirme

OrbisHub SDK'sı ile kendi özel agent'larınızı geliştirebilirsiniz:

```javascript
const { OrbisAgent } = require('orbis-hub-sdk');

// Agent oluşturun
const agent = new OrbisAgent({
  name: 'My Custom Agent',
  capabilities: ['custom-task']
});

// Görev işleyici tanımlayın
agent.registerTaskHandler('custom-task', async (task, context) => {
  // Görev işleme mantığı
  return { result: 'İşlem tamamlandı' };
});

// Agent'ı başlatın
agent.start();
```

Örnek agent'lar için `examples/` dizinine bakın.

## Katkı Sağlama

Katkı sağlamak için lütfen bir Pull Request oluşturun. Büyük değişiklikler için önce bir Issue açarak değişikliği tartışmak için zaman ayırın.

## Lisans

Bu proje [MIT lisansı](LICENSE) altında lisanslanmıştır.

---

© 2025 OrbisLabs.ai