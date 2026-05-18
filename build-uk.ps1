# Builds UA version from current PL index.html.
# Re-run any time PL is updated.
$src = 'D:\bordo salon\site\index.html'
$dst = 'D:\bordo salon\site\uk\index.html'

$h = [System.IO.File]::ReadAllText($src, [System.Text.Encoding]::UTF8)

# === Lang / canonical / hreflang / og locale ===
$h = $h.Replace('<html lang="pl">', '<html lang="uk">')
$h = $h.Replace('<title>Bordo · Studio urody we Wrocławiu · Rzęsy, Brwi, Laser</title>',
                '<title>Bordo · Студія краси у Вроцлаві · Вії, Брови, Лазер</title>')
$h = $h.Replace('Bordo · studio urody w sercu Wrocławia. Przedłużanie rzęs, stylizacja brwi, depilacja laserowa, makijaż. Władysława Jagiełły 3/7 · Śródmieście. Obsługa po polsku i ukraińsku.',
                'Bordo · студія краси у серці Вроцлава. Нарощування вій, стилізація брів, лазерна епіляція, макіяж. Władysława Jagiełły 3/7 · Śródmieście. Обслуговування українською та польською.')
$h = $h.Replace('<link rel="canonical" href="https://youngandbeautiful.pl/">',
                '<link rel="canonical" href="https://youngandbeautiful.pl/uk/">')
$h = $h.Replace('<meta property="og:url" content="https://youngandbeautiful.pl/">',
                '<meta property="og:url" content="https://youngandbeautiful.pl/uk/">')

# === JSON-LD: UA-specific url + inLanguage + description ===
$h = $h.Replace('"@id": "https://youngandbeautiful.pl/#salon"',
                '"@id": "https://youngandbeautiful.pl/uk/#salon"')
$h = $h.Replace('"@id": "https://youngandbeautiful.pl/#faq"',
                '"@id": "https://youngandbeautiful.pl/uk/#faq"')
$h = $h.Replace('"inLanguage": "pl-PL"',
                '"inLanguage": "uk-UA"')
$h = $h.Replace('"description": "Studio urody w sercu Wrocławia: przedłużanie i laminacja rzęs, stylizacja i laminacja brwi, depilacja laserowa, makijaż. Trzy poziomy mistrzów (Junior · Top · Art). Obsługa po polsku i ukraińsku."',
                '"description": "Студія краси у серці Вроцлава: нарощування і ламінація вій, стилізація і ламінація брів, лазерна епіляція, макіяж. Три рівні майстрів (Junior · Top · Art). Обслуговування українською та польською."')

# === FAQPage JSON-LD: PL → UA per Q+A ===
$h = $h.Replace('{"@type":"Question","name":"Czy depilacja laserowa boli?","acceptedAnswer":{"@type":"Answer","text":"Krótkotrwałe pulsowanie z chłodzeniem skóry. Większość klientek nazywa to „znośne". Pracujemy na aparacie z głowicą chłodzącą, to znacząco zmniejsza dyskomfort."}}',
                '{"@type":"Question","name":"Чи болить лазерна епіляція?","acceptedAnswer":{"@type":"Answer","text":"Короткотривале пульсування з охолодженням шкіри. Більшість клієнток називає це «стерпно». Працюємо на апараті з охолоджувальною головкою, це суттєво зменшує дискомфорт."}}')
$h = $h.Replace('{"@type":"Question","name":"Ile zabiegów lasera potrzebuję?","acceptedAnswer":{"@type":"Answer","text":"Od 6 do 8 sesji w odstępach 4–8 tygodni. Test-impuls przed pierwszą wizytą, gratis. Każda kolejna sesja daje wyraźnie widoczny efekt."}}',
                '{"@type":"Question","name":"Скільки сеансів лазера потрібно?","acceptedAnswer":{"@type":"Answer","text":"Від 6 до 8 сеансів з інтервалом 4–8 тижнів. Тест-імпульс перед першим візитом, безкоштовно. Кожен наступний сеанс дає помітний ефект."}}')
$h = $h.Replace('{"@type":"Question","name":"Czy mogę przyjść z opalenizną?","acceptedAnswer":{"@type":"Answer","text":"Nie zalecamy. Prosimy o 2–4 tyg. bez słońca i SPF 50 przed wizytą, to kwestia bezpieczeństwa skóry."}}',
                '{"@type":"Question","name":"Чи можна приходити із засмагою?","acceptedAnswer":{"@type":"Answer","text":"Не рекомендуємо. Просимо 2–4 тиж. без сонця і SPF 50 перед візитом, це питання безпеки шкіри."}}')
$h = $h.Replace('{"@type":"Question","name":"Naprawdę nie zniszczę swoich rzęs?","acceptedAnswer":{"@type":"Answer","text":"Przy poprawnej technice, nie. Stosujemy hipoalergiczny klej Sky i materiały lekkie, dobierane do struktury Twoich rzęs naturalnych."}}',
                '{"@type":"Question","name":"Чи справді я не зіпсую свої вії?","acceptedAnswer":{"@type":"Answer","text":"За правильної техніки, ні. Використовуємо гіпоалергенний клей і легкі матеріали, підібрані під структуру твоїх натуральних вій."}}')
$h = $h.Replace('{"@type":"Question","name":"Czy brwi po laminacji wyglądają naturalnie?","acceptedAnswer":{"@type":"Answer","text":"Tak. O intensywności decydujemy razem z Tobą na konsultacji, od bardzo delikatnego efektu „uczesanych" brwi do mocniejszego."}}',
                '{"@type":"Question","name":"Чи виглядають брови після ламінації натурально?","acceptedAnswer":{"@type":"Answer","text":"Так. Про інтенсивність вирішуємо разом із тобою на консультації, від дуже делікатного ефекту «причесаних» брів до яскравішого."}}')
$h = $h.Replace('{"@type":"Question","name":"Jak długo trzyma się efekt?","acceptedAnswer":{"@type":"Answer","text":"Laminacja brwi ~5–6 tygodni, rzęsy 3–4 tygodnie, laser, efekt narasta po 3. zabiegu i po pełnym cyklu utrzymuje się latami."}}',
                '{"@type":"Question","name":"Як довго тримається ефект?","acceptedAnswer":{"@type":"Answer","text":"Ламінація брів ~5–6 тиж., вії 3–4 тиж., лазер, ефект наростає після 3-го сеансу і після повного циклу тримається роками."}}')
$h = $h.Replace('{"@type":"Question","name":"W jakim języku możemy się porozumieć?","acceptedAnswer":{"@type":"Answer","text":"Polski i ukraiński. Każdy mistrz mówi w obu językach, nie zgubisz niuansów konsultacji."}}',
                '{"@type":"Question","name":"Якою мовою ми можемо спілкуватися?","acceptedAnswer":{"@type":"Answer","text":"Польська та українська. Кожен майстер говорить обома мовами, не загубиш нюансів консультації."}}')
$h = $h.Replace('{"@type":"Question","name":"Czy mogę odwołać wizytę?","acceptedAnswer":{"@type":"Answer","text":"Tak, do 24 godzin przed wizytą, bezpłatnie. Później zatrzymujemy 50% kaucji. Pierwsza rezerwacja zawsze bez kaucji."}}',
                '{"@type":"Question","name":"Чи можна скасувати візит?","acceptedAnswer":{"@type":"Answer","text":"Так, до 24 годин до візиту, безкоштовно. Пізніше утримуємо 50% застави. Перший запис завжди без застави."}}')
$h = $h.Replace('"url": "https://youngandbeautiful.pl/"',
                '"url": "https://youngandbeautiful.pl/uk/"')
$h = $h.Replace('<meta property="og:locale" content="pl_PL">',
                '<meta property="og:locale" content="uk_UA">')
$h = $h.Replace('<meta property="og:locale:alternate" content="uk_UA">',
                '<meta property="og:locale:alternate" content="pl_PL">')
$h = $h.Replace('content="Bordo · Studio urody we Wrocławiu"',
                'content="Bordo · Студія краси у Вроцлаві"')
$h = $h.Replace('content="Rzęsy, brwi, laser, makijaż. Władysława Jagiełły 3/7. Sterylne studio · sprawdzone materiały · dwa języki obsługi."',
                'content="Вії, брови, лазер, макіяж. Władysława Jagiełły 3/7. Стерильна студія · перевірені матеріали · дві мови обслуговування."')
$h = $h.Replace('content="Rzęsy, brwi, laser, makijaż w sercu Wrocławia. PL · UA."',
                'content="Вії, брови, лазер, макіяж у серці Вроцлава. PL · UA."')

# === Lang switcher state ===
$h = $h.Replace('<a href="/" class="active" aria-current="page">PL</a>
        <span class="sep">·</span>
        <a href="/uk/">UA</a>',
                '<a href="/">PL</a>
        <span class="sep">·</span>
        <a href="/uk/" class="active" aria-current="page">UA</a>')

# === Header / Nav ===
$h = $h.Replace('aria-label="Główne"', 'aria-label="Головне"')
$h = $h.Replace('aria-label="Język"', 'aria-label="Мова"')
$h = $h.Replace('aria-label="Bordo · strona główna"', 'aria-label="Bordo · головна сторінка"')
$h = $h.Replace('>Usługi</a>', '>Послуги</a>')
$h = $h.Replace('>Cennik</a>', '>Ціни</a>')
$h = $h.Replace('>Studio</a>', '>Студія</a>')
$h = $h.Replace('>Opinie</a>', '>Відгуки</a>')
$h = $h.Replace('class="btn btn-secondary" data-cta="header">Zarezerwuj</a>',
                'class="btn btn-secondary" data-cta="header">Записатися</a>')
$h = $h.Replace('aria-label="Menu"', 'aria-label="Меню"')

# === Hero ===
$h = $h.Replace('Studio urody · Wrocław · Śródmieście', 'Студія краси · Wrocław · Śródmieście')
$h = $h.Replace('Rzęsy, brwi i&nbsp;depilacja laserowa<br>
      <em>bez pośpiechu, bez gwiazdek.</em>',
                'Вії, брови та&nbsp;лазерна епіляція<br>
      <em>без поспіху, без зірочок.</em>')
$h = $h.Replace('90 minut spokoju w&nbsp;centrum Wrocławia.<br>Wychodzisz z&nbsp;efektem, którego nie trzeba tłumaczyć znajomym.',
                '90 хвилин спокою у&nbsp;центрі Вроцлава.<br>Виходиш із&nbsp;ефектом, який не треба пояснювати подругам.')
$h = $h.Replace('Władysława Jagiełły 3/7 · wejście z&nbsp;ulicy',
                'Władysława Jagiełły 3/7 · вхід з&nbsp;вулиці')
$h = $h.Replace('class="btn btn-primary" data-cta="hero-primary">Umów pierwszą wizytę</a>',
                'class="btn btn-primary" data-cta="hero-primary">Записатися на перший візит</a>')
$h = $h.Replace('class="btn btn-outline-mute">Zobacz usługi</a>',
                'class="btn btn-outline-mute">Дивитися послуги</a>')

# === Pierwsza wizyta band ===
$h = $h.Replace('<strong>Bez kaucji</strong>Pierwsza rezerwacja, zawsze bez przedpłaty.',
                '<strong>Без застави</strong>Перший запис, завжди без передоплати.')
$h = $h.Replace('<strong>Konsultacja gratis</strong>Kilka minut na rozmowę przed dotykiem.',
                '<strong>Консультація безкоштовно</strong>Кілька хвилин на розмову перед дотиком.')
$h = $h.Replace('<strong>Test alergiczny</strong>Przed pierwszym zabiegiem, bez opłaty.',
                '<strong>Алергопроба</strong>Перед першою процедурою, безкоштовно.')
$h = $h.Replace('<strong>Łatwo nas znaleźć</strong>Bordowe drzwi · wejście z&nbsp;ulicy.',
                '<strong>Нас легко знайти</strong>Бордові двері · вхід з&nbsp;вулиці.')
$h = $h.Replace('<strong>Gwarancja jakości</strong>Nawet do&nbsp;3 tygodni od&nbsp;zabiegu.',
                '<strong>Гарантія якості</strong>Навіть до&nbsp;3 тижнів від&nbsp;процедури.')

# === Pricing tier chips ===
$h = $h.Replace('aria-label="Trzy poziomy mistrzów"', 'aria-label="Три рівні майстрів"')
$h = $h.Replace('<div class="tier-chip start"><strong>Start</strong>pewne ręce, sprawdzona technika</div>',
                '<div class="tier-chip start"><strong>Start</strong>впевнені руки, перевірена техніка</div>')
$h = $h.Replace('<div class="tier-chip"><strong>Top</strong>doświadczone stylistki, 3+ lata</div>',
                '<div class="tier-chip"><strong>Top</strong>досвідчені стилістки, 3+ роки</div>')
$h = $h.Replace('<div class="tier-chip art"><strong>Art</strong>ekspertka z portfolio</div>',
                '<div class="tier-chip art"><strong>Art</strong>експертка з портфоліо</div>')

# === Pricing tiered rows (Lashes) ===
$h = $h.Replace('<span class="lbl">Start</span>', '<span class="lbl">Start</span>')
# Note: tier prices stay as numbers; tier names "Start/Top/Art", international labels, no translation needed.

# === Skip-link ===
$h = $h.Replace('<a class="skip-link" href="#main">Przejdź do treści</a>',
                '<a class="skip-link" href="#main">Перейти до змісту</a>')

# === Twój rytm Bordo ===
$h = $h.Replace('<div class="caption">Twój rytm Bordo</div>', '<div class="caption">Твій ритм Bordo</div>')
$h = $h.Replace('Biologia już wie, kiedy <em>wracasz</em>.',
                'Біологія вже знає, коли <em>повертаєшся</em>.')
$h = $h.Replace('<div class="svc">Rzęsy</div>
        <div class="freq">co 3–4 tyg.</div>
        <div class="what">Uzupełnienie 110–140 zł, przy obecności od&nbsp;40% przedłużanych rzęs.</div>',
                '<div class="svc">Вії</div>
        <div class="freq">кожні 3–4 тиж.</div>
        <div class="what">Заповнення 110–140 zł, за наявності від&nbsp;40% нарощених вій.</div>')
$h = $h.Replace('<div class="svc">Brwi</div>
        <div class="freq">co 5–6 tyg.</div>
        <div class="what">Laminacja brwi, pełna stylizacja na ponad miesiąc.</div>',
                '<div class="svc">Брови</div>
        <div class="freq">кожні 5–6 тиж.</div>
        <div class="what">Ламінація брів, повна стилізація на понад місяць.</div>')
$h = $h.Replace('<div class="svc">Henna</div>
        <div class="freq">co ~3 tyg.</div>
        <div class="what">Odświeżenie koloru, między laminacjami.</div>',
                '<div class="svc">Хна</div>
        <div class="freq">кожні ~3 тиж.</div>
        <div class="what">Освіження кольору, між ламінаціями.</div>')
$h = $h.Replace('<div class="svc">Laser</div>
        <div class="freq">co 4–8 tyg.</div>
        <div class="what">Pełen cykl 6–8 zabiegów. Efekt narasta po 3. sesji.</div>',
                '<div class="svc">Лазер</div>
        <div class="freq">кожні 4–8 тиж.</div>
        <div class="what">Повний цикл 6–8 сеансів. Ефект наростає після 3-го сеансу.</div>')
$h = $h.Replace('Po wizycie wysyłamy WhatsAppem przypomnienie<br>w&nbsp;odpowiednim momencie.
      <strong>Bez listy mailingowej. Jeden sygnał, zero spamu.</strong>',
                'Після візиту надсилаємо нагадування у&nbsp;WhatsApp<br>у&nbsp;потрібний момент.
      <strong>Без поштової розсилки. Один сигнал, нуль спаму.</strong>')

# === Razem do Bordo ===
$h = $h.Replace('<div class="caption">Razem do Bordo</div>', '<div class="caption">Razem do Bordo</div>')
$h = $h.Replace('Najlepsze opinie zaczynają się <em>od&nbsp;rekomendacji.</em>',
                'Найкращі відгуки починаються <em>з&nbsp;рекомендації.</em>')
$h = $h.Replace('Przyprowadź koleżankę, lub przyjdź razem do&nbsp;Bordo na pierwszy raz.<br>Obie wychodzicie z&nbsp;bonusem na kolejną wizytę.',
                'Приведи подругу, або приходьте разом до&nbsp;Bordo вперше.<br>Обидві виходите з&nbsp;бонусом на наступний візит.')
$h = $h.Replace('<div class="lbl"><strong>dla obu</strong>na każdą kolejną wizytę</div>',
                '<div class="lbl"><strong>для обох</strong>на кожен наступний візит</div>')
$h = $h.Replace('Po wizycie dostaniesz osobisty kod w&nbsp;WhatsAppie. Wystarczy podzielić się nim z&nbsp;koleżanką.',
                'Після візиту отримаєш особистий код у&nbsp;WhatsApp. Достатньо поділитися ним із&nbsp;подругою.')
$h = $h.Replace('<div class="lbl">Opinii klientek</div>', '<div class="lbl">Відгуків клієнток</div>')
$h = $h.Replace('<div class="lbl">Lat doświadczenia</div>', '<div class="lbl">Років досвіду</div>')
$h = $h.Replace('<div class="lbl">Dwa języki obsługi</div>', '<div class="lbl">Дві мови обслуговування</div>')

# === Services ===
$h = $h.Replace('<div class="caption">Usługi</div>', '<div class="caption">Послуги</div>')
$h = $h.Replace('Każda procedura, <em>jak mały rytuał.</em>',
                'Кожна процедура, <em>як невеликий ритуал.</em>')
$h = $h.Replace('Cztery kierunki, jedna estetyka. Pracujemy bez pośpiechu, z konsultacją na początku i&nbsp;pyszną kawę lub herbatę ☕️',
                'Чотири напрями, одна естетика. Працюємо без поспіху, з&nbsp;консультацією на початку та&nbsp;смачною кавою чи&nbsp;чаєм ☕️')
$h = $h.Replace('<div class="caption">Procedura · 90–120 min</div>
        <div class="title">Rzęsy</div>
        <div class="desc">Naturalne lub spektakularne, efekt do 5 tygodni.</div>',
                '<div class="caption">Процедура · 90–120 хв</div>
        <div class="title">Вії</div>
        <div class="desc">Натуральні або яскраві, ефект до 5 тижнів.</div>')
$h = $h.Replace('<div class="caption">Procedura · 60 min</div>
        <div class="title">Brwi</div>
        <div class="desc">Architektura, henna, laminacja, naturalna forma na każdy dzień.</div>',
                '<div class="caption">Процедура · 60 хв</div>
        <div class="title">Брови</div>
        <div class="desc">Архітектура, пудрова хна, ламінація, натуральна форма на кожен день.</div>')
$h = $h.Replace('<div class="caption">Procedura · 15–60 min</div>
        <div class="title">Laser</div>
        <div class="desc">Bezpiecznie, bezboleśnie, dla każdego typu skóry, z testem przed cyklem.</div>',
                '<div class="caption">Процедура · 15–60 хв</div>
        <div class="title">Лазер</div>
        <div class="desc">Безпечно, безболісно, для будь-якого типу шкіри, з тестом перед циклом.</div>')
$h = $h.Replace('<div class="caption">Procedura · 60–90 min</div>
        <div class="title">Makijaż</div>
        <div class="desc">Express, dzienny, wieczorowy, ślubny, z konsultacją tonu i&nbsp;próbą.</div>',
                '<div class="caption">Процедура · 60–90 хв</div>
        <div class="title">Макіяж</div>
        <div class="desc">Експрес, денний, вечірній, весільний, з&nbsp;консультацією тону та&nbsp;пробою.</div>')
$h = $h.Replace('<span class="pre">od</span>', '<span class="pre">від</span>')

# === Pakiety section (replaces old Sygnatura) ===
$h = $h.Replace('<div class="caption">Pakiety Bordo</div>', '<div class="caption">Пакети Bordo</div>')
$h = $h.Replace('Trzy ścieżki, <em>jeden adres.</em>', 'Три шляхи, <em>одна адреса.</em>')
$h = $h.Replace('Najczęściej wybierane kombinacje, bo brwi, rzęsy i&nbsp;laser nie żyją osobno.',
                'Найчастіше обрані комбінації, бо брови, вії та&nbsp;лазер не живуть окремо.')

# Pakiet 1: Powitalny
$h = $h.Replace('<div class="label">Pakiet Powitalny</div>', '<div class="label">Пакет Привітальний</div>')
$h = $h.Replace('Brwi <em>+</em> Rzęsy<br>w&nbsp;jednej wizycie',
                'Брови <em>+</em> Вії<br>за&nbsp;один візит')
$h = $h.Replace('Architektura brwi z&nbsp;henną pudrową plus przedłużanie rzęs metodą 1:1 (Start). Pełen efekt w&nbsp;90&nbsp;minut.',
                'Архітектура брів з&nbsp;пудровою хною плюс нарощування вій методом 1:1 (Start). Повний ефект за&nbsp;90&nbsp;хвилин.')
$h = $h.Replace('Brwi w&nbsp;cenie · zamiast 60+130 zł osobno',
                'Брови у&nbsp;вартості · замість 60+130 zł окремо')
$h = $h.Replace('class="cta" data-cta="pakiet-powitalny">Zarezerwuj pakiet →</a>',
                'class="cta" data-cta="pakiet-powitalny">Записатися на пакет →</a>')

# Pakiet 2: Top Signature (featured)
$h = $h.Replace('<div class="badge">Nasz wybór</div>', '<div class="badge">Наш вибір</div>')
$h = $h.Replace('<div class="label">Pakiet Top Signature</div>', '<div class="label">Пакет Top Signature</div>')
$h = $h.Replace('Rzęsy Top <em>+</em> Laminacja brwi',
                'Вії Top <em>+</em> Ламінація брів')
$h = $h.Replace('Dla stałych klientek, przedłużanie rzęs Top 1:1 plus zestaw laminacja brwi (regulacja, farbowanie, laminacja).',
                'Для постійних клієнток, нарощування вій Top 1:1 плюс комплекс ламінації брів (корекція, фарбування, ламінація).')
$h = $h.Replace('Oszczędzasz 41&nbsp;zł · zamiast 160+130 zł osobno',
                'Економите 41&nbsp;zł · замість 160+130 zł окремо')
$h = $h.Replace('class="cta" data-cta="pakiet-top-signature">Zarezerwuj pakiet →</a>',
                'class="cta" data-cta="pakiet-top-signature">Записатися на пакет →</a>')

# Pakiet 3: Twarz
$h = $h.Replace('<div class="label">Pakiet Twarz</div>', '<div class="label">Пакет Обличчя</div>')
$h = $h.Replace('Laser <em>+</em> Brwi<br>jedno popołudnie',
                'Лазер <em>+</em> Брови<br>один день')
$h = $h.Replace('Laser na małej partii (np. wąsik) plus pełna stylizacja brwi: regulacja, farbowanie, laminacja.',
                'Лазер на малій ділянці (напр. вусики) плюс повна стилізація брів: корекція, фарбування, ламінація.')
$h = $h.Replace('Oszczędzasz 10&nbsp;zł · zamiast 79+150 zł osobno',
                'Економите 10&nbsp;zł · замість 79+150 zł окремо')
$h = $h.Replace('class="cta" data-cta="pakiet-twarz">Zarezerwuj pakiet →</a>',
                'class="cta" data-cta="pakiet-twarz">Записатися на пакет →</a>')

$h = $h.Replace('Brak ukrytych opłat · Konsultacja gratis · Pierwsza wizyta bez kaucji',
                'Без прихованих витрат · Консультація безкоштовно · Перший візит без застави')

# === Why ===
$h = $h.Replace('<div class="caption">Dlaczego Bordo</div>', '<div class="caption">Чому Bordo</div>')
$h = $h.Replace('Cztery rzeczy, na których <em>nie idziemy na kompromis.</em>',
                'Чотири речі, у&nbsp;яких ми <em>не йдемо на компроміс.</em>')
$h = $h.Replace('<h3>Sterylność jak w&nbsp;klinice</h3>
        <p>Każdy instrument, autoklaw. Każdy zabieg, jednorazowa wkładka. Sterylizator stoi na widoku, nie chowamy go za drzwiami.</p>',
                '<h3>Стерильність як у&nbsp;клініці</h3>
        <p>Кожен інструмент, автоклав. Кожна процедура, одноразова вкладка. Стерилізатор на видноті, не ховаємо його за дверима.</p>')
$h = $h.Replace('<h3>Materiały, które znamy</h3>
        <p>Pracujemy tylko na Lash &amp; Co, BeautierLashes, Henna Brow oraz hipoalergicznym kleju Sky. Test alergiczny przed pierwszym zabiegiem, gratis.</p>',
                '<h3>Матеріали, які ми знаємо</h3>
        <p>Працюємо лише з Lash &amp; Co, BeautierLashes, Henna Brow та гіпоалергенним клеєм Sky. Алергопроба перед першою процедурою, безкоштовно.</p>')
$h = $h.Replace('<h3>Dwa języki, jedno podejście</h3>
        <p>PL · UA, bez utraty znaczenia. Konsultacja w&nbsp;Twoim języku to mniej napięcia i&nbsp;lepszy efekt.</p>',
                '<h3>Дві мови, один підхід</h3>
        <p>PL · UA, без втрати сенсу. Консультація твоєю мовою, менше напруги, кращий результат.</p>')
$h = $h.Replace('<h3>Trzy poziomy, Twój wybór</h3>
        <p>Start, Top albo Art, sama decydujesz. Te same materiały, ten sam standard sterylności. Różnica tylko w&nbsp;doświadczeniu mistrza i&nbsp;cenie.</p>',
                '<h3>Три рівні, твій вибір</h3>
        <p>Start, Top або Art, сама вирішуєш. Ті самі матеріали, той самий стандарт стерильності. Різниця лише в&nbsp;досвіді майстра і&nbsp;ціні.</p>')

# === Before/After ===
$h = $h.Replace('<div class="caption">Przed · Po</div>', '<div class="caption">До · Після</div>')
$h = $h.Replace('Bez filtrów. Bez retuszu.<br><em>Tylko światło, kąt i&nbsp;czas.</em>',
                'Без фільтрів. Без ретуші.<br><em>Лише світло, кут та&nbsp;час.</em>')
$h = $h.Replace('<span class="tag l">Przed</span><span class="tag r">Po</span>',
                '<span class="tag l">До</span><span class="tag r">Після</span>')
$h = $h.Replace('Rzęsy 2D · Anna · 2026', 'Вії 2D · Анна · 2026')
$h = $h.Replace('Brwi · Karolina · 2026', 'Брови · Кароліна · 2026')
$h = $h.Replace('Rzęsy 3D · Maria · 2026', 'Вії 3D · Марія · 2026')
$h = $h.Replace('Laser · Klientka · 2026', 'Лазер · Клієнтка · 2026')
$h = $h.Replace('Makijaż · Joanna · 2026', 'Макіяж · Йоанна · 2026')
$h = $h.Replace('Brwi · Olga · 2026', 'Брови · Ольга · 2026')
$h = $h.Replace('class="text-link" data-cta="ba-card">Zarezerwuj efekt</a>',
                'class="text-link" data-cta="ba-card">Записатися на ефект</a>')
$h = $h.Replace('205 opinii Google · <a href="#testi" class="text-link">przeczytaj</a>',
                '205 відгуків Google · <a href="#testi" class="text-link">читати</a>')
$h = $h.Replace('aria-label="Poprzednie"', 'aria-label="Попередні"')
$h = $h.Replace('aria-label="Następne"', 'aria-label="Наступні"')

# === Pricing ===
$h = $h.Replace('<div class="caption">Cennik</div>', '<div class="caption">Ціни</div>')
$h = $h.Replace('<em>Otwarcie</em> i&nbsp;bez gwiazdek.', '<em>Відкрито</em> і&nbsp;без зірочок.')
$h = $h.Replace('Pełen cennik usług, <a href="https://youngandbeautiful.booksy.com/a/" target="_blank" rel="noopener" class="text-link">na Booksy</a>. Tutaj, najpopularniejsze pozycje.',
                'Повний прайс послуг, <a href="https://youngandbeautiful.booksy.com/a/" target="_blank" rel="noopener" class="text-link">на Booksy</a>. Тут, найпопулярніші позиції.')
$h = $h.Replace('<h3>Rzęsy</h3>', '<h3>Вії</h3>')
$h = $h.Replace('<h3>Brwi</h3>', '<h3>Брови</h3>')
$h = $h.Replace('<h3>Laser</h3>', '<h3>Лазер</h3>')
$h = $h.Replace('<h3>Makijaż</h3>', '<h3>Макіяж</h3>')

# Laser prices
$h = $h.Replace('<span class="name">Małe partie <span style="color:var(--c-mute);font-family:var(--f-body);font-size:11px;letter-spacing:.04em">(wąsik, baki…)</span></span>',
                '<span class="name">Малі ділянки <span style="color:var(--c-mute);font-family:var(--f-body);font-size:11px;letter-spacing:.04em">(вусики, бакенбарди…)</span></span>')
$h = $h.Replace('<span class="name">Średnie partie <span style="color:var(--c-mute);font-family:var(--f-body);font-size:11px;letter-spacing:.04em">(pachy, bikini…)</span></span>',
                '<span class="name">Середні ділянки <span style="color:var(--c-mute);font-family:var(--f-body);font-size:11px;letter-spacing:.04em">(пахви, бікіні…)</span></span>')
$h = $h.Replace('<span class="name">Duże partie <span style="color:var(--c-mute);font-family:var(--f-body);font-size:11px;letter-spacing:.04em">(twarz, łydki…)</span></span>',
                '<span class="name">Великі ділянки <span style="color:var(--c-mute);font-family:var(--f-body);font-size:11px;letter-spacing:.04em">(обличчя, гомілки…)</span></span>')
$h = $h.Replace('<span class="name">Pachy + Bikini głęb.</span>', '<span class="name">Пахви + Глибоке бікіні</span>')
$h = $h.Replace('<span class="name">Test-impuls</span><span class="leader"></span><span class="amt">gratis</span>',
                '<span class="name">Тест-імпульс</span><span class="leader"></span><span class="amt">безкоштовно</span>')
$h = $h.Replace('Pełen cennik lasera (11) →', 'Повний прайс лазера (11) →')
$h = $h.Replace('Pełen cennik brwi (7) →', 'Повний прайс брів (7) →')

# Lashes prices (tiered rows + single rows)
$h = $h.Replace('<span class="name">Przedłużanie 1:1</span>', '<span class="name">Нарощування 1:1</span>')
$h = $h.Replace('<span class="name">Przedłużanie 2:1</span>', '<span class="name">Нарощування 2:1</span>')
$h = $h.Replace('<span class="name">Przedłużanie 3:1</span>', '<span class="name">Нарощування 3:1</span>')
$h = $h.Replace('<span class="name">Laminacja <span style="color:var(--c-mute);font-family:var(--f-body);font-size:11px;letter-spacing:.04em">(+&nbsp;botox w&nbsp;cenie)</span></span>',
                '<span class="name">Ламінація <span style="color:var(--c-mute);font-family:var(--f-body);font-size:11px;letter-spacing:.04em">(+&nbsp;ботокс у&nbsp;вартості)</span></span>')
$h = $h.Replace('<span class="name">Henna rzęs</span><span class="leader"></span><span class="amt">30 zł</span>',
                '<span class="name">Хна вій</span><span class="leader"></span><span class="amt">30 zł</span>')
$h = $h.Replace('Pełen cennik rzęs (23) →', 'Повний прайс вій (23) →')

# Brows prices
$h = $h.Replace('<span class="name">Regulacja brwi</span>', '<span class="name">Корекція форми</span>')
$h = $h.Replace('<span class="name">Farbowanie + regulacja</span>', '<span class="name">Фарбування + корекція</span>')
$h = $h.Replace('<span class="name">Laminacja brwi</span>', '<span class="name">Ламінація брів</span>')
$h = $h.Replace('<span class="name">Zestaw laminacja <span style="color:var(--c-mute);font-family:var(--f-body);font-size:11px;letter-spacing:.04em">(reg.&nbsp;+&nbsp;farb.&nbsp;+&nbsp;lam.)</span></span>',
                '<span class="name">Комплекс ламінація <span style="color:var(--c-mute);font-family:var(--f-body);font-size:11px;letter-spacing:.04em">(кор.&nbsp;+&nbsp;фарб.&nbsp;+&nbsp;лам.)</span></span>')
$h = $h.Replace('<span class="name">Depilacja wąsik</span>', '<span class="name">Депіляція вусиків</span>')
$h = $h.Replace('Pełen cennik brwi →', 'Повний прайс брів →')

# Makeup prices
$h = $h.Replace('<span class="name">Express makijaż</span>', '<span class="name">Експрес-макіяж</span>')
$h = $h.Replace('<span class="name">Dzienny / biznes</span>', '<span class="name">Денний / бізнес</span>')
$h = $h.Replace('<span class="name">Wieczorowy</span>', '<span class="name">Вечірній</span>')
$h = $h.Replace('<span class="name">Ślubny</span>', '<span class="name">Весільний</span>')
$h = $h.Replace('<span class="name">Stylizacja włosów <span style="color:var(--c-mute);font-family:var(--f-body);font-size:11px;letter-spacing:.04em">(loki)</span></span>',
                '<span class="name">Укладка волосся <span style="color:var(--c-mute);font-family:var(--f-body);font-size:11px;letter-spacing:.04em">(локони)</span></span>')
$h = $h.Replace('Pełen cennik makijażu →', 'Повний прайс макіяжу →')

$h = $h.Replace('<strong>Laser, bezpłatny test-impuls</strong> przed pierwszą wizytą. Pakiety: 2 partie 259 zł · 3 partie 359 zł · 5 partii 509 zł · całe ciało 709 zł.<br>
      <strong>Każda Start-praca</strong> sprawdzana przez Top-stylistkę przed wyjściem klientki. Te same materiały, ten sam standard sterylności na każdym poziomie.<br>
      <strong>Płatność:</strong> gotówka · karta · BLIK · Booksy · Apple/Google Pay',
                '<strong>Лазер, безкоштовний тест-імпульс</strong> перед першим візитом. Пакети: 2 ділянки 259 zł · 3 ділянки 359 zł · 5 ділянок 509 zł · все тіло 709 zł.<br>
      <strong>Кожна Start-робота</strong> перевіряється Top-стилісткою перед виходом клієнтки. Ті самі матеріали, той самий стандарт стерильності на кожному рівні.<br>
      <strong>Оплата:</strong> готівка · карта · BLIK · Booksy · Apple/Google Pay')

# === Process ===
$h = $h.Replace('<div class="caption">Jak to wygląda</div>', '<div class="caption">Як це виглядає</div>')
$h = $h.Replace('Trzy kroki, <em>od pomysłu do efektu.</em>',
                'Три кроки, <em>від ідеї до результату.</em>')
$h = $h.Replace('<div class="num">01 · Rezerwacja</div>
        <h3>Booksy lub WhatsApp</h3>
        <p>Odpowiadamy w&nbsp;ciągu 5&nbsp;minut w&nbsp;godzinach pracy. Bez przedpłaty dla pierwszych klientek.</p>',
                '<div class="num">01 · Запис</div>
        <h3>Booksy або WhatsApp</h3>
        <p>Відповідаємо протягом 5&nbsp;хвилин у&nbsp;робочий час. Без передоплати для перших клієнток.</p>')
$h = $h.Replace('<div class="num">02 · Wizyta</div>
        <h3>Konsultacja i&nbsp;zabieg</h3>
        <p>Propozycja formy i&nbsp;efektu, sam zabieg w&nbsp;komforcie. Czaj, woda, koc, atelier, nie konwejer.</p>',
                '<div class="num">02 · Візит</div>
        <h3>Консультація і&nbsp;процедура</h3>
        <p>Пропозиція форми та&nbsp;ефекту, сама процедура у&nbsp;комфорті. Чай, вода, плед, ательє, не конвеєр.</p>')
$h = $h.Replace('<div class="num">03 · Po wizycie</div>
        <h3>Aftercare i&nbsp;kontakt</h3>
        <p>Karta aftercare, WhatsApp dla pytań. Przypomnimy o&nbsp;korekcie w&nbsp;odpowiednim czasie.</p>',
                '<div class="num">03 · Після візиту</div>
        <h3>Aftercare і&nbsp;контакт</h3>
        <p>Карта aftercare, WhatsApp для питань. Нагадаємо про корекцію у&nbsp;потрібний час.</p>')

# === Testimonials ===
$h = $h.Replace('<div class="caption">Opinie</div>', '<div class="caption">Відгуки</div>')
$h = $h.Replace('Słowo klientek, <em>głośniej niż reklama.</em>',
                'Слова клієнток, <em>гучніше за рекламу.</em>')
$h = $h.Replace('Kolejny miesiąc i&nbsp;kolejne przepiękne rzęski. Dziękuję bardzo&nbsp;❤️',
                'Черговий місяць і&nbsp;чергові прекрасні вії. Дуже дякую&nbsp;❤️')
$h = $h.Replace('<div class="name">Veronika</div>
        <div class="svc">Przedłużanie rzęs 2:1 · kwi 2026</div>',
                '<div class="name">Вероніка</div>
        <div class="svc">Нарощування вій 2:1 · кві 2026</div>')
$h = $h.Replace('Bardzo miłe Panie, wszystko super, szybko i&nbsp;sprawnie. Jestem zadowolona&nbsp;🥰',
                'Дуже милі дівчата, все супер, швидко і&nbsp;злагоджено. Я задоволена&nbsp;🥰')
$h = $h.Replace('<div class="name">Kasia</div>
        <div class="svc">Laminacja rzęs + farbka + botox · kwi 2026</div>',
                '<div class="name">Кася</div>
        <div class="svc">Ламінація вій + фарбування + ботокс · кві 2026</div>')
$h = $h.Replace('Bardzo dokładna i&nbsp;w&nbsp;delikatny sposób wykonana usługa. Polecam&nbsp;:)',
                'Дуже акуратно і&nbsp;делікатно виконана послуга. Рекомендую&nbsp;:)')
$h = $h.Replace('<div class="name">Klaudia</div>
        <div class="svc">Henna rzęs · mar 2026</div>',
                '<div class="name">Клаудія</div>
        <div class="svc">Хна вій · бер 2026</div>')
$h = $h.Replace('<div class="count">205 opinii klientek</div>', '<div class="count">205 відгуків клієнток</div>')
$h = $h.Replace('<div class="lbl">205 opinii klientek</div>', '<div class="lbl">205 відгуків клієнток</div>')
$h = $h.Replace('class="btn btn-secondary">Przeczytaj wszystkie</a>',
                'class="btn btn-secondary">Читати всі</a>')

# === Studio & Team ===
$h = $h.Replace('<div class="caption">Studio &amp; zespół</div>', '<div class="caption">Студія та команда</div>')
$h = $h.Replace('Miejsce, gdzie czujesz się jak w&nbsp;domu<br><em>jeśli Twój dom pachnie kawą i&nbsp;bordo.</em>',
                'Місце, де ти&nbsp;відчуваєш себе як удома<br><em>якщо твій дім пахне кавою і&nbsp;бордо.</em>')
$h = $h.Replace('<div class="name">Art</div>
          <div class="role">Najwyższy poziom</div>
          <div class="yrs">Mistrzowie z najdłuższym stażem</div>',
                '<div class="name">Art</div>
          <div class="role">Найвищий рівень</div>
          <div class="yrs">Майстрині з найдовшим стажем</div>')
$h = $h.Replace('<div class="name">Top</div>
          <div class="role">Doświadczone stylistki</div>
          <div class="yrs">Lata pracy &amp; setki klientek</div>',
                '<div class="name">Top</div>
          <div class="role">Досвідчені стилістки</div>
          <div class="yrs">Роки практики &amp; сотні клієнток</div>')
$h = $h.Replace('<div class="name">Start</div>
          <div class="role">Świetny początek</div>
          <div class="yrs">Te same materiały, niższa cena</div>',
                '<div class="name">Start</div>
          <div class="role">Чудовий початок</div>
          <div class="yrs">Ті самі матеріали, нижча ціна</div>')
$h = $h.Replace('<div class="name">Brwi Art</div>
          <div class="role">Stylistka brwi</div>
          <div class="yrs">Architektura, henna, laminacja</div>',
                '<div class="name">Brwi Art</div>
          <div class="role">Стилістка брів</div>
          <div class="yrs">Архітектура, хна, ламінація</div>')

# === FAQ ===
$h = $h.Replace('Najczęstsze pytania.', 'Найчастіші запитання.')
$h = $h.Replace('Czy depilacja laserowa boli?', 'Чи болить лазерна епіляція?')
$h = $h.Replace('Krótkotrwałe pulsowanie z&nbsp;chłodzeniem skóry. Większość klientek nazywa to „znośne”. Pracujemy na aparacie z&nbsp;głowicą chłodzącą, to znacząco zmniejsza dyskomfort.',
                'Короткотривале пульсування з&nbsp;охолодженням шкіри. Більшість клієнток називає це «стерпно». Працюємо на апараті з&nbsp;охолоджувальною головкою, це суттєво зменшує дискомфорт.')
$h = $h.Replace('Ile zabiegów lasera potrzebuję?', 'Скільки сеансів лазера потрібно?')
$h = $h.Replace('Od&nbsp;6&nbsp;do&nbsp;8 sesji w&nbsp;odstępach 4–8 tygodni. Test-impuls przed pierwszą wizytą, gratis. Każda kolejna sesja daje wyraźnie widoczny efekt.',
                'Від&nbsp;6&nbsp;до&nbsp;8 сеансів з&nbsp;інтервалом 4–8 тижнів. Тест-імпульс перед першим візитом, безкоштовно. Кожен наступний сеанс дає помітний ефект.')
$h = $h.Replace('Czy mogę przyjść z&nbsp;opalenizną?', 'Чи можна приходити із&nbsp;засмагою?')
$h = $h.Replace('Nie zalecamy. Prosimy o&nbsp;2–4 tyg. bez słońca i&nbsp;SPF&nbsp;50 przed wizytą, to kwestia bezpieczeństwa skóry.',
                'Не рекомендуємо. Просимо 2–4 тиж. без сонця і&nbsp;SPF&nbsp;50 перед візитом, це питання безпеки шкіри.')
$h = $h.Replace('Naprawdę nie zniszczę swoich rzęs?', 'Чи справді я&nbsp;не зіпсую свої вії?')
$h = $h.Replace('Przy poprawnej technice, nie. Stosujemy hipoalergiczny klej i&nbsp;materiały lekkie, dobierane do struktury Twoich rzęs naturalnych.',
                'За правильної техніки, ні. Використовуємо гіпоалергенний клей і&nbsp;легкі матеріали, підібрані під структуру твоїх натуральних вій.')
$h = $h.Replace('Czy brwi po laminacji wyglądają naturalnie?', 'Чи виглядають брови після ламінації натурально?')
$h = $h.Replace('Tak. O&nbsp;intensywności decydujemy razem z&nbsp;Tobą na konsultacji, od bardzo delikatnego efektu „uczesanych” brwi do mocniejszego.',
                'Так. Про інтенсивність вирішуємо разом із&nbsp;тобою на консультації, від дуже делікатного ефекту «причесаних» брів до яскравішого.')
$h = $h.Replace('Jak długo trzyma się efekt?', 'Як довго тримається ефект?')
$h = $h.Replace('Laminacja brwi ~5–6 tyg., rzęsy 3–4 tyg., laser, efekt narasta po 3. zabiegu i&nbsp;po pełnym cyklu utrzymuje się latami.',
                'Ламінація брів ~5–6 тиж., вії 3–4 тиж., лазер, ефект наростає після 3-го сеансу і&nbsp;після повного циклу тримається роками.')
$h = $h.Replace('W&nbsp;jakim języku możemy się porozumieć?', 'Якою мовою ми можемо спілкуватися?')
$h = $h.Replace('Polski i&nbsp;ukraiński. Każdy mistrz mówi w&nbsp;obu językach, nie zgubisz niuansów konsultacji.',
                'Польська та&nbsp;українська. Кожен майстер говорить обома мовами, не загубиш нюансів консультації.')
$h = $h.Replace('Czy mogę odwołać wizytę?', 'Чи можна скасувати візит?')
$h = $h.Replace('Tak, do&nbsp;24 godzin przed wizytą, bezpłatnie. Później zatrzymujemy 50% kaucji. Pierwsza rezerwacja zawsze bez kaucji.',
                'Так, до&nbsp;24 годин до візиту, безкоштовно. Пізніше утримуємо 50% застави. Перший запис завжди без застави.')

# === Location ===
$h = $h.Replace('<div class="caption">Kontakt</div>', '<div class="caption">Контакт</div>')
$h = $h.Replace('Znajdź nas <em>w&nbsp;centrum Wrocławia.</em>', 'Знайди нас <em>у&nbsp;центрі Вроцлава.</em>')
$h = $h.Replace('aria-label="Mapa Wrocław Jagiełły 3/7"', 'aria-label="Мапа Вроцлав, Ягеллі 3/7"')
$h = $h.Replace('<div class="caption" style="margin-bottom:14px">Adres</div>',
                '<div class="caption" style="margin-bottom:14px">Адреса</div>')
$h = $h.Replace('2 minuty od Rynku · 5 min od Dworca Głównego.<br>Wejście z&nbsp;ulicy.',
                '2 хвилини від Ринку · 5 хв від Головного вокзалу.<br>Вхід з&nbsp;вулиці.')
$h = $h.Replace('<div class="lbl">Godziny pracy</div>', '<div class="lbl">Години роботи</div>')
$h = $h.Replace('<dt>Pon–Pt</dt>', '<dt>Пн–Пт</dt>')
$h = $h.Replace('<dt>Sobota</dt>', '<dt>Субота</dt>')
$h = $h.Replace('<dt>Niedziela</dt><dd style="color:var(--c-mute)">zamknięte</dd>',
                '<dt>Неділя</dt><dd style="color:var(--c-mute)">зачинено</dd>')
$h = $h.Replace('<div class="lbl">Kontakt</div>', '<div class="lbl">Контакт</div>')
$h = $h.Replace('<dt>Telefon</dt>', '<dt>Телефон</dt>')
$h = $h.Replace('Cze%C5%9B%C4%87%21%20Chc%C4%99%20zarezerwowa%C4%87%20wizyt%C4%99%20w%20Bordo.',
                'Pryvit%21%20Hochu%20zapysatys%CC%8Ca%20do%20Bordo.')
$h = $h.Replace('class="btn btn-primary" data-cta="location-whatsapp" style="align-self:flex-start;margin-top:8px">Napisz na WhatsApp</a>',
                'class="btn btn-primary" data-cta="location-whatsapp" style="align-self:flex-start;margin-top:8px">Напиши у WhatsApp</a>')

# === Final CTA ===
$h = $h.Replace('<div class="caption">Gotowa?</div>', '<div class="caption">Готова?</div>')
$h = $h.Replace('Pierwsza wizyta<br><em>to nie zobowiązanie.</em><br>To rozmowa.',
                'Перший візит<br><em>це не зобов''язання.</em><br>Це розмова.')
$h = $h.Replace('Konsultacja przy każdym zabiegu, bezpłatna. Bez sprzedaży, bez naciągania na pakiety. Powiesz tak, zapraszamy. Powiesz nie, też się nie obrazimy.',
                'Консультація перед кожною процедурою, безкоштовна. Без продажів, без нав''язування пакетів. Скажеш так, запрошуємо. Скажеш ні, теж не образимося.')
$h = $h.Replace('class="btn btn-primary" data-cta="final">Zarezerwuj wizytę</a>',
                'class="btn btn-primary" data-cta="final">Записатися на візит</a>')
$h = $h.Replace('lub napisz:', 'або напиши:')

# === Footer ===
$h = $h.Replace('Studio urody w&nbsp;sercu Wrocławia.<br>PL · UA',
                'Студія краси у&nbsp;серці Вроцлава.<br>PL · UA')
$h = $h.Replace('<h4>Usługi</h4>', '<h4>Послуги</h4>')
# Footer service column, individual replaces (order-independent vs header nav rules above)
$h = $h.Replace('<li><a href="#services">Rzęsy</a></li>', '<li><a href="#services">Вії</a></li>')
$h = $h.Replace('<li><a href="#services">Brwi</a></li>', '<li><a href="#services">Брови</a></li>')
$h = $h.Replace('<li><a href="#services">Laser</a></li>', '<li><a href="#services">Лазер</a></li>')
$h = $h.Replace('<li><a href="#services">Makijaż</a></li>', '<li><a href="#services">Макіяж</a></li>')
# Note: Cennik footer item already became "Ціни" via header nav rule (>Cennik</a> → >Ціни</a>)

$h = $h.Replace('<h4>Studio</h4>', '<h4>Студія</h4>')

# Footer studio column, individual replaces
$h = $h.Replace('<li><a href="#studio">O nas</a></li>', '<li><a href="#studio">Про нас</a></li>')
$h = $h.Replace('<li><a href="#studio">Zespół</a></li>', '<li><a href="#studio">Команда</a></li>')
# Note: Opinie footer item already became "Відгуки" via header nav rule
$h = $h.Replace('<h4>Kontakt</h4>', '<h4>Контакт</h4>')
$h = $h.Replace('<li>Pon–Pt 10–20 · Sob 10–18</li>', '<li>Пн–Пт 10–20 · Сб 10–18</li>')
$h = $h.Replace('© 2026 Bordo Beauty Studio · Z dbałością o szczegół, z Wrocławia',
                '© 2026 Bordo Beauty Studio · Зі смаком до деталей, із Вроцлава')
$h = $h.Replace('<a href="mailto:youngandbeautiful.wro@gmail.com?subject=Pytanie%20o%20polityk%C4%99%20prywatno%C5%9Bci">Polityka prywatności</a>',
                '<a href="mailto:youngandbeautiful.wro@gmail.com?subject=%D0%9F%D0%B8%D1%82%D0%B0%D0%BD%D0%BD%D1%8F%20%D0%BF%D1%80%D0%BE%20%D0%BF%D0%BE%D0%BB%D1%96%D1%82%D0%B8%D0%BA%D1%83%20%D0%BA%D0%BE%D0%BD%D1%84%D1%96%D0%B4%D0%B5%D0%BD%D1%86%D1%96%D0%B9%D0%BD%D0%BE%D1%81%D1%82%D1%96">Політика конфіденційності</a>')
$h = $h.Replace('<a href="mailto:youngandbeautiful.wro@gmail.com?subject=Pytanie%20o%20regulamin">Regulamin</a>',
                '<a href="mailto:youngandbeautiful.wro@gmail.com?subject=%D0%9F%D0%B8%D1%82%D0%B0%D0%BD%D0%BD%D1%8F%20%D0%BF%D1%80%D0%BE%20%D1%80%D0%B5%D0%B3%D0%BB%D0%B0%D0%BC%D0%B5%D0%BD%D1%82">Регламент</a>')

# === Cookie consent footer link (banner texts are translated in consent.js by <html lang>) ===
$h = $h.Replace('<a href="#" data-bc-open>Ustawienia cookies</a>',
                '<a href="#" data-bc-open>Налаштування cookies</a>')

# === Google Maps embed: locale params + title ===
$h = $h.Replace('!3m2!1spl!2spl!4v', '!3m2!1suk!2spl!4v')
$h = $h.Replace('!5m2!1spl!2spl', '!5m2!1suk!2spl')
$h = $h.Replace('title="Mapa · Bordo Beauty Studio, Władysława Jagiełły 3/7, Wrocław"',
                'title="Мапа · Bordo Beauty Studio, Władysława Jagiełły 3/7, Вроцлав"')

# === Sticky mobile ===
$h = $h.Replace('class="btn btn-primary" data-cta="sticky-booksy">Zarezerwuj</a>',
                'class="btn btn-primary" data-cta="sticky-booksy">Записатися</a>')

[System.IO.File]::WriteAllText($dst, $h, (New-Object System.Text.UTF8Encoding $true))
"UA built: $dst ($([System.IO.File]::ReadAllBytes($dst).Length) bytes)"
