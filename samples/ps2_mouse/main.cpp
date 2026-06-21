#include <kdf.h>

// Çekirdeğin bize sunduğu donanım/yazdırma fonksiyon köprüsü
static KernelAPI* k_api = nullptr;

// Farenin anlık durum string'ini tutacağımız buffer
static char mouse_status_str[64] = "x=0,y=0,l=0,r=0";

// DEDK veya terminal komutu 'read' yaptığında bu ortak fonksiyon tetiklenecek
int mouse_read(void* buffer, uint32_t size) {
    if (!buffer || size == 0) return -1;
    
    char* dest = (char*)buffer;
    const char* src = mouse_status_str;
    uint32_t i = 0;
    
    for (; i < size - 1 && src[i] != '\0'; i++) {
        dest[i] = src[i];
    }
    dest[i] = '\0';
    
    return i;
}

int mouse_control(const char* command, void* arg, uint32_t arg_size) {
    (void)command; (void)arg; (void)arg_size;
    return 0;
}

// SÜRÜCÜ BAŞLANGIÇ HEADER YAPISI
// .text.head bölümüne yazarak linker'ın bunu en başa fırlatmasını sağlıyoruz
extern "C" {
    __attribute__((section(".text.head"))) __attribute__((used)) 
    KDF_Header driver_header = {
        .magic = KDF_MAGIC,
        .driver_version = 0x00000001,
        .driver_name = "ps2_mouse",
        .init_offset = sizeof(KDF_Header), // Kod direkt header'dan sonra başlayacak
        .exit_offset = 0,
        .code_size = 0
    };
}

// SÜRÜCÜNÜN ASIL GİRİŞ NOKTASI
extern "C" int driver_init(KernelAPI* api, KDF_Operations* ops) {
    k_api = api;
    
    k_api->printk("[ps2_mouse.kdf] Surucu basariyla ilklendirildi!\n");

    ops->read = mouse_read;
    ops->write = nullptr;
    ops->control = mouse_control;

    // TODO: mouse_ps2.c içindeki IRQ 12 kesme kaydı ve port açma kodları buraya gelecek

    return 0;
}