# TodoAppWithGolangServiceMongoDB

|*|*|
|--|--|
|Database|MongoDB|
|Service|Golang|
|App|iOS UIKit|

# Golang Tarafı

1. MongoDB kullanıldı veri tabanı olarak
2. Package şeklinde katmanlar oluşturuldu.

* app package (Handler'ların bulunduğu kısım)
* Models katmanı
* Repository katmanı
* Services katmanı
* Mock katmanı (Test için)

3. Mock Unit Test Yazılması
4. Dependency Injection (Unit Test için çok önemli)

## Golang Paketleri

1. Fiber

Hızlı ve verimli bir şekilde çalışan bir HTTP sunucusu sağlar. Fiber, hafif bir framework olmasına rağmen, web uygulamalarının geliştirilmesinde gereken tüm özelliklere sahiptir. Bu özellikler arasında yönlendirme, istek/response middleware'leri, şablonlama, veritabanı bağlantıları, WebSocket desteği ve diğer birçok özellik bulunur. Fiber, hızı ve performansıyla bilinir. Golang'ın doğal olarak hızlı olmasına ek olarak, Fiber geliştiricileri, yüksek performanslı HTTP sunucusu olarak ün kazanmış olan Fasthttp kütüphanesini kullanarak daha da hızlı bir hale getirdi. Fiber, Go programlama dili için oldukça popüler bir web framework'üdür ve özellikle yüksek trafikli web siteleri ve uygulamalar için idealdir.

2. GoDotEnv kullanıldı.

 .env dosyalarını okumak ve bu dosyalardaki anahtar-değer çiftlerini kullanarak ortam değişkenlerini ayarlamak için kullanılır. .env dosyaları, uygulamaların çalışması için gerekli olan çeşitli yapılandırma değişkenlerini içeren bir dosya türüdür. Örneğin, veritabanı bağlantı bilgileri, kimlik doğrulama anahtarları, API anahtarları vb. gibi öğeleri içerebilir. GoDotEnv, uygulama yapılandırmasını basitleştirmek için kullanılır. Bu kütüphane, .env dosyalarındaki yapılandırma değişkenlerini yükler ve uygulamanın çalışması için gereken ortam değişkenlerini ayarlar. Bu, uygulamanın farklı ortamlarda (geliştirme, test, prodüksiyon vb.) çalışmasını kolaylaştırır ve uygulamanın yapılandırmasını değiştirmek için tek bir .env dosyasını güncellemeyi sağlar.

3. Mockery

Mockery, bir arayüzün (interface) mock sınıflarını otomatik olarak oluşturarak, kod testlerinde kullanmak için yardımcı olur. Mocking, bir test ortamında bir bileşenin davranışını taklit etmek için yapay bir nesne kullanmaktır. Böylece, gerçek bileşenin yerine kullanılabilen yapay bir nesne (mock object) oluşturulur ve testlerin daha güvenli ve tahmin edilebilir hale gelmesi sağlanır. Mockery, kod testlerinde kullanılan mock sınıflarını oluşturmak için kullanılır. Bu sınıflar, testlerin gerçek bileşenlerin yerine kullanılması için kullanılabilir ve böylece testlerin daha kontrol edilebilir hale gelmesine yardımcı olur.

4. Testify

Golang Testify, Go programlama dili için bir testing framework'üdür. Testify, Go dilinde yazılan testlerin daha okunaklı, daha anlaşılır ve daha kolay yönetilebilir hale gelmesine yardımcı olur. estify, Go dilinde standart kütüphanedeki test araçlarına ek olarak birçok faydalı araç sağlar. Bunlar arasında testlerin daha net ve daha anlaşılır hale getirilmesine yardımcı olan assertion fonksiyonları, mock sınıfları oluşturmak için araçlar, ve testlerin koşullu olarak çalıştırılmasını sağlayan ifade bazlı test özellikleri yer alır. Testify ayrıca, test verilerinin hazırlanması ve yönetimi için de faydalı araçlar sunar. Bu araçlar, testlerin daha kolay yönetilmesine ve karmaşık test senaryolarının daha kolay oluşturulmasına yardımcı olur.

## Kullanılan Github Repoları ve MongoDB Driver

* go.mongodb.org/mongo-driver/mongo
* go.mongodb.org/mongo-driver/mongo/options
* go.mongodb.org/mongo-driver/bson/primitive
* github.com/gofiber/fiber/v2
* github.com/golang/mock/gomock
* github.com/stretchr/testify/assert
* github.com/joho/godotenv

## Not

Mock'lama yapılması için şu satır yazılıyor. Detaylar kod satırında

```//go:generate mockgen -destination=../mocks/service/mockTodoservice.go -package=services omerfarukozturk.com/backend/services TodoService```

# iOS UIKit Tarafı

...
