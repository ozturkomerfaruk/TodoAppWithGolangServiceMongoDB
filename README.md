# TodoAppWithGolangServiceMongoDB

|*|*|
|--|--|
|Database|MongoDB|
|Service|Golang|
|App|iOS UIKit|

Burada amaç, bir markete yayımlanma kaygısı gütmeden ya da, olabilecek en az hata kaygısı gütmeden şekilde kodlar yazılmamıştır. Burada amaç tamamen yeni kavramlar öğrenmek olduğu için sürekli yeni şeyler deneme üzerinde durulmuştur. Ne iOS tarafında ne Go tarafında mükemmel ötesi kodlar bulamazsınız ancak son derece de elimden geldiğince yeni şeyleri, güzel bir ifadeyle kodları yazmaya çalıştım.

Readme dosyasını okuduktan sonra aklınıza takılan detay kavramlar varsa, ya da sormak istediğiniz herhangi bir şey **iletisim@omerfarukozturk.com** mail adresine çekinmeden sorabilirsiniz. Gerekirse Discord, Zoom vs. girer bakarız tek tek.

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

## Launch, Onboarding & Login

https://user-images.githubusercontent.com/56068905/229043174-3d8bfd9a-2f07-4998-a5c1-fa75c6eae46b.mov

* 3 saniye içerisinde otomatik atlanan bir launch screen bulunmaktadır. Burada Animasyonla alpha değeri 0'dan 1'e çıkan bir yazı ve bir de Lottie kullanılmaktadır. 
* Ardından Onboarding Screen bulunmaktadır ki, bu uygulama tanıtım için tasarlanan bir ekrandır. Kullanıcı bir kez uygulamaya giriş yaptıktan sonra bir daha karşısına çıkmaz. 
* Ardından Login ve Register bizi karşılamakta. Burada, ilk dikkati çeken husus, animasyonlu gradient kullanımıdır ve yuvarlak bir objenin yanıp sönme animasyonudur. Burada kullanıcı kayıt olur ardından giriş yapar. Giriş yaparken token uretilir ve bu token ile her yerde kullanılabilir. Bu token'ı Keychain Access ile tutuyorum ve servisde kullanıyorum. Ardından bir AlertView gösterimi var ve devamında diğer sayfaya giriş yapılıyor. Eğer kullanıcı adı ve şifresi yanlış girilirse uyarı vermekte.

## Todo Listesi, Todo Ekleme

### Part 1
https://user-images.githubusercontent.com/56068905/229044099-a3090921-0bfb-4cc6-91bd-6b14924cf914.mov

### Part 2
https://user-images.githubusercontent.com/56068905/229045615-3d7caaaf-6de2-45c7-8933-9d18b9d12c96.mov

* Todo'ların listelendiği bir ekran bulunmakta. Ancak todo'lar kullanıcıya özel olarak listelenmekte. Yani admin panelinden bakar gibi değilde kullanıcının sadece kendi kaydettiği Todo'lar bulunmakta. Ayrıca sayfanın yukarısında bu zamana kadar olan tüm todo'ların listesi bulunmakta. Diğer tarafında da, tarihte bugüne ait todoların listesi bulunmakta. Eğer hiçbir todo yoksa yüzde olarak 100 göstermekte yani tüm todolar yapılmış denilmekte.
* Ardından Todo kaydetme ekranında; başlık, kategori seçme, tarih ve zaman seçme, içeriğini doldurma gibi seçenekler bulunmaktadır. Bir todo kaydedilirken ilk başta yüzdelik değeri 0 olmaktadır.
* Daha sonra ana ekrana dönünce, yüzdelik değerler ve Todo sayısı ekranda yazmaktadır. Eğer listede bir Todo'ya girer ve yüzdelik değerini değiştirirsek, günlük ya da toplam yüzdelik değerimizde duruma göre değişmektedir.
* Ayrıca Detay ekranında güncelleme yapabilmek için sağ üst tarafta bulunan **Edit** butonuna tıklayarak güncelleme yapılmaktadır ve burada bulunan kategoriler kısmında, **Collection View** bulunmakta ve burada bulunan son **Cell** 'in bir buton olma özelliği bulunmaktadır. Bu buton sayesinde yeni kategori eklenebilmektedir.
* Ana ekranda bulunan listede kullanıcı isterse hem TableView görünümü ile Todo'larına bakabilir hemde CollectionView ile bakabilir.

**Not:** Bu ekranlarda yapılabilecek çok fazla değişiklik bulunmakta. Örneğin en son CollectionView seçildikten sonra, UserDefault'a kaydederek kullanıcı tekrar uygulamaya girdiğinde de CollectionView'ı görebilmekte olur. Ancak amacım sadece yeni şeyler denemek olduğu için çok fazla değişiklik olmadan bırakıyorum uygulamayı.

## Profil

https://user-images.githubusercontent.com/56068905/229048603-2c50385f-ddf2-4254-b995-84d5c627ed47.mov

Profil ekranında kullanıcı isterse kendi resmini profil resmi yapabilir. Ayrıca bu profil resmi MongoDB'ye de kaydedilmektedir. Binary'e dönüştürüp resmi kaydediyorum. Detaylar Go tarafında kodlarda mevcut. İsmini girerse, hitap edilmeye başlanabilir. Kullanıcı eğer isterse şifresini değiştirebilir, ayarlarda e-mail ekleyebilir ya da çıkış yapabilir.

## Ayarlar

https://user-images.githubusercontent.com/56068905/229046076-85942b22-f9a7-4434-8be1-961604b6f182.mov

Aslında benim amacım bu ayarlar tarafında çok fazla seçenekler eklemekti. Örneğin tema ayarlama, canlı dil değiştirme seçenekleri vs. Tüm bunlar çok hızlı bir şekilde yapılabilir ancak ben sıkıldığım için bırakıyorum uygulamayı :D Bu projede amacım daha çok MongoDB ile uğraşmak ve Go dilini öğrenmekti. Bu sayfada ise kullanıcı mail'ini eğer kaydederse, ve bir gün şifresini unutursa diye, şifre sıfırlama için bir mail göndermekteyim.

## Deeplink & Şifre Sıfırlama

https://user-images.githubusercontent.com/56068905/229047306-3c5d66cb-4a8f-4f34-8792-0eac26e1d6d6.mov

Kullanıcıya bir mail gönderilmekte. Bu gönderme işlemi Go da yapılmakta. Go da ayrıca bir HTML formatında yazdığım kod satırları ile mail'i göndermekteyim. Butona tıkladığında ise, bir deeplink çalışmakta. Bu deeplink'i SceneDelegate içerisinde yazdığım kod ile açmaktayım uygulamayı. Ardından Deeplink içerisinde bulunan mail ile kullanıcıya iOS tarafında ulaşabilmekteyim ve ekrana bir şifre sıfırlama ekranı açmaktayım. Kullanıcı yeni şifresini giriyor ve şifresi başarıyla sıfırlanmış olmakta.

## Kullanılan Kütüphaneler

4 adet kütüphane kullandım.
|Kütüphaneler|Açıklaması|
|---|---|
|Alamofire|Alamofire, Swift programlama dili için HTTP istekleri göndermek ve almak için kullanılan açık kaynaklı bir kütüphanedir.|
|KeychainAccess|KeychainAccess, iOS uygulamaları için kullanıcı kimlik bilgileri, şifreler, anahtarlar ve diğer hassas verilerin güvenli bir şekilde depolanmasını sağlayan bir kütüphanedir.|
|Lottie|Lottie, JSON biçiminde animasyonlar oluşturmayı ve bunları iOS, Android ve web uygulamalarına entegre etmeyi kolaylaştıran bir kütüphanedir.|
|SwiftAlertView|SwiftAlertView, iOS uygulamaları için özelleştirilebilir ve kullanımı kolay bir bildirim mesajı görüntüleyicisi sağlayan açık kaynaklı bir kütüphanedir.|

## Mimari Yapı

Projede **Protocol Oriented MVVM** kullanılmıştır. Bunun en büyük sebebi Unit Test yazılması için böyle yapılmıştır. Ama valla sıkıldığım için yarıda bırakıyorum ancak Mock Unit Test nasıl yazılır eğer öğrenmek istiyorsanız benimle iletişime geçebilirsiniz. Çok basit bir yapısı var ancak burada yarıda bırakıyorum.

## Sayfa Yapısı

<img width="675" alt="image" src="https://user-images.githubusercontent.com/56068905/229049990-519e06de-8122-4ceb-b86f-393de7079977.png">

Profil ekranında kullanıcı isterse kendi resmini profil resmi yapabilir. Ayrıca bu profil resmi MongoDB'ye de kaydedilmektedir. Binary'e dönüştürüp resmi kaydediyorum. Detaylar Go tarafında kodlarda mevcut. İsmini girerse, hitap edilmeye başlanabilir. Kullanıcı eğer isterse şifresini değiştirebilir, ayarlarda e-mail ekleyebilir ya da çıkış yapabilir.
