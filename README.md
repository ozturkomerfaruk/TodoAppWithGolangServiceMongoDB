# TodoAppWithGolangServiceMongoDB

|*|*|
|--|--|
|Database|MongoDB|
|Service|Golang|
|App|iOS UIKit|

Burada amaç, bir markete yayımlanma kaygısı gütmeden ya da, olabilecek en az hata kaygısı gütmeden şekilde kodlar yazılmamıştır. Burada amaç tamamen yeni kavramlar öğrenmek olduğu için sürekli yeni şeyler deneme üzerinde durulmuştur. Ne iOS tarafında ne Go tarafında mükemmel ötesi kodlar bulamazsınız ancak son derece de elimden geldiğince yeni şeyleri, güzel bir ifadeyle kodları yazmaya çalıştım.

# Golang MongoDB Tarafı

MongoDB kullanılarak Golang ile servisler yazılmıştır. Yazılan tüm servisler Postman aracılığıyla test edilerek yazılmıştır. Tüm servisler:
<img width="750" alt="Screenshot 2023-03-31 at 06 57 05" src="https://user-images.githubusercontent.com/56068905/229024412-2d68b74a-17cf-4352-a8df-696748f6acde.png">

Golang, **Clean Architecture** ve **Repository Pattern** kullanılarak geliştirilmiştir.
1. Repository katmanı (repository): Veritabanı işlemleri ve depolama yönetimi için sorumlu olan bu katman, UserRepositoryDB gibi yapıları içerir. Bu katman, veri kaynağına erişim sağlar ve CRUD işlemlerini yönetir.
2. Service katmanı (services): İş mantığını ve uygulama düzeyindeki işlemleri yöneten bu katman, DefaultUserService gibi yapıları içerir. Bu katman, iş akışlarını ve gerekli yönergeleri uygular.
3. Handler katmanı (app): HTTP isteklerini ve yanıtlarını yöneten ve uygulamanın API'sini tanımlayan bu katman, UserHandler gibi yapıları içerir. Bu katman, istemciden gelen istekleri işler ve uygun servis ve repository katmanlarını kullanarak işlemleri gerçekleştirir.
main fonksiyonu: Uygulamanın başlatıldığı ve tüm bileşenlerin bir araya getirildiği yerdir. İşlemler ve yapılandırma burada tanımlanır.

Bu yapı, uygulamanın farklı bileşenlerini soyutlamak ve bağımlılıkları yönetmek için kullanışlıdır. Bu sayede, uygulama daha kolay test edilebilir ve bakımı yapılarak geliştirilebilir. Todo tarafının kodları yazılırken Unit Test yazılmıştır. Unit test kavramına giriş yapıldıktan sonra daha fazla zaman kaybetmemek için geçilmiştir.

Örnek kodlara geçmeden önce, kullanıcı **Şifremi Unuttum** dediğinde, kullanıcıya sistemde kayıtlı olduğu mailine Google Gmail SMPT üzerinden mail gönderilmektedir. Bu mail sayesinde kullanıcıya bir deeplink gelmektedir. Bu deeplink sayesinde kullanıcı parolasını değiştirebilmektedir. Kullanıcıya gelen mail'in formatı bir HTML üzerinden hazırlanarak yapılmıştır. Örnek HTML kodu bulunmaktadır.

Kullanıcı giriş yaparken bir token üretmektedir ve hemen hemen bütün servislerde token kullanılmaktadır. Sadece token, parolamı unuttum kısmında yoktur ve bir de tabi kayıt olurken sisteme yoktur. Örnek kodlar tamamen erişime açıktır inceleyebilirsiniz.

## Kullanılan kütüphaneler
|Kütüphane|Açıklaması|
|---|---|
|github.com/gofiber/fiber/v2|Bu, Go programlama dili için hızlı, esnek ve basit bir web framework'ü olan Fiber'ın ikinci sürümünün kaynak kodunu barındıran açık kaynaklı bir GitHub kütüphanesidir.|
|go.mongodb.org/mongo-driver/bson/primitive|Bu, Go programlama dili için MongoDB BSON belgelerinin temel veri türlerinin işlenmesi ve işlemesi için bir kütüphanedir.|
|golang.org/x/crypto/bcrypt|Bu, Go programlama dili için bcrypt şifreleme algoritmasını uygulayan bir kütüphanedir.|
|gopkg.in/gomail.v2|Bu, Go programlama dili için e-posta gönderimi işlevselliği sağlayan bir kütüphanedir.|
|"github.com/gofiber/jwt/v3"|Bu, Go programlama dili için Fiber web framework'ü ile kullanım için JSON Web Token (JWT) yetkilendirme kütüphanesidir.|
|"github.com/golang-jwt/jwt/v4"|Bu da aynı kütüphanedir JWT. Ancak versiyon farklı|
|"github.com/golang/mock/gomock"|Bu, Go programlama dili için ünite testlerinde kullanılmak üzere mock objeler oluşturmayı kolaylaştıran bir kütüphane olan gomock'un kontrolörlerini (controllers) içeren bir pakettir.|
|"github.com/stretchr/testify/assert"|Bu, Go programlama dili için yazılım testlerinin yazılmasını kolaylaştıran açık kaynaklı bir kütüphanedir ve assert (doğrulama) işlevleri sağlar.|

# iOS UIKit Tarafı

Detaylı bir yazı yazacağım. Çok fazla sayfa tasarımı yapıldı. Projenin tamamlanmasını bekliyorum.
