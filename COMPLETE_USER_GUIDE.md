# 📚 Полное руководство пользователя TaxLien.online

## Дата: 14 октября 2025

---

## 🏠 1. КАК СМОТРЕТЬ УЧАСТКИ БЕЗ ЗАКЛАДНЫХ

### Способ 1: Расширенный поиск (Рекомендуется)

```
Маркетплейс → 🔍 (иконка поиска) → Configure Filters
```

**Шаги:**
1. Откройте вкладку **"Маркетплейс"** (вторая снизу)
2. Нажмите иконку **🔍 Search** (справа вверху)
3. Откроется "Advanced Search"
4. Нажмите **"Configure"** (настроить фильтры)
5. Перейдите на вкладку **"Property"**
6. Выберите **Status → "Available"** (доступно, без активных закладных)
7. Нажмите **"Apply"**

**Результат:** Увидите только участки БЕЗ активных закладных

### Способ 2: Быстрая фильтрация в маркетплейсе

```
Маркетплейс → Фильтр (иконка tune)
```

**Доступные quick filters:**
- 📍 Штат (State)
- 📍 County (округ)
- 💰 Диапазон цен
- 📊 Процентная ставка
- ✅ Статус (Available, Sold, Redeemed)

---

## 🏛️ 2. КАК СМОТРЕТЬ УЧАСТКИ С АКТИВНЫМИ ЗАКЛАДНЫМИ

### В Advanced Search:

```
Маркетплейс → 🔍 Search → Configure
```

**Настройка фильтров:**
1. **Tab "Property"** → Status: **"Sold"** или **"Active"**
2. Дополнительно можно фильтровать по:
   - Штат и county
   - Диапазон процентных ставок
   - Сумма закладной
   - Дата выдачи закладной

### Фильтры для закладных:

| Фильтр | Описание | Пример |
|--------|----------|--------|
| Status: Available | Участки БЕЗ закладных | Свободные для покупки |
| Status: Active | Участки С закладными | Активные закладные |
| Status: Sold | Проданные | Уже куплены |
| Status: Redeemed | Погашенные | Владелец выкупил |
| Status: Cancelled | Отмененные | Сделка не состоялась |

---

## 📊 3. КАК СМОТРЕТЬ СТАТИСТИКУ ПО КОНКУРЕНТАМ

### Вариант A: В Portfolio (Портфель)

```
Портфель → Вкладка "Статистика"
```

**Что доступно:**
1. **Общая статистика рынка:**
   - Средняя цена закладных
   - Средняя процентная ставка
   - Количество активных инвесторов
   - Объем рынка

2. **Статистика по штатам:**
   - Топ штатов по активности
   - Средняя доходность
   - Количество закладных

3. **Статистика по counties:**
   - Популярные округа
   - Средние цены
   - Уровень конкуренции

### Вариант B: AI Советник

```
AI Советник → Market Analysis
```

**AI предоставляет:**
- Анализ рыночных трендов
- Сравнение с конкурентами
- Рекомендации по стратегии
- Прогнозы доходности

### Вариант C: Portfolio Dashboard

```
Портфель → Performance Tab
```

**Доступная аналитика:**
- 📈 График доходности
- 💼 Распределение по штатам
- 🎯 Сравнение с рыночными показателями
- 📊 ROI метрики

---

## 📜 4. КАК СМОТРЕТЬ ИСТОРИЧЕСКИЕ ДАННЫЕ

### Способ 1: Preload Info Screen

```
Профиль → Данные приложения
```

**Что показывается:**
1. **Исторические коллекции:**
   - Данные за 2024 год
   - Polk County, FL
   - Dixie County, FL  
   - Putnam County, FL

2. **Статистика по counties:**
   - Total liens (общее количество)
   - Total value (общая стоимость)
   - Average interest rate (средняя ставка)
   - Collection dates (даты сбора)

3. **Sample tax liens:**
   - Примеры исторических закладных
   - Полная информация по каждой
   - Статусы и даты

### Способ 2: В Marketplace с фильтром по датам

```
Маркетплейс → Advanced Search → Configure
```

**Настройка:**
1. **Financial Tab:**
   - Issue Date Range (диапазон дат выдачи)
   - Min/Max Issue Date

2. **Например:**
   - Min Issue Date: 01/01/2024
   - Max Issue Date: 12/31/2024
   - Результат: Все закладные за 2024 год

### Способ 3: Historical Data API (программно)

Через PreloadService доступны методы:

```dart
// Получить исторические данные
final historical = await PreloadService.getHistoricalTaxLiens();

// По округу
final polkData = await PreloadService.getTaxLiensByCounty('Polk');

// По году
final year2024 = await PreloadService.getTaxLiensByCollectionYear('2024');

// По диапазону процентных ставок
final highRate = await PreloadService.getTaxLiensByInterestRateRange(15.0, 20.0);
```

---

## 🎯 5. ПОЛНЫЙ СПИСОК ДОСТУПНЫХ ФИЛЬТРОВ

### 📍 Локация:
- ✅ State (штат) - FL, AZ, TX, CA и др.
- ✅ County (округ) - Polk, Miami-Dade и др.
- ✅ City (город)
- ✅ ZIP Code (почтовый индекс)

### 💰 Финансовые:
- ✅ Tax Amount (сумма налога) - Min/Max
- ✅ Interest Rate (процентная ставка) - Min/Max  
- ✅ Assessed Value (оценочная стоимость) - Min/Max
- ✅ Price Range (диапазон цен) - Min/Max

### 🏡 Недвижимость:
- ✅ Property Type (тип) - Residential, Commercial, Industrial
- ✅ Lot Size (размер участка) - Min/Max sq ft
- ✅ Bedrooms (спальни) - Min/Max
- ✅ Bathrooms (ванные) - Min/Max

### 📅 Статус и Даты:
- ✅ Status - Available, Active, Sold, Redeemed, Cancelled
- ✅ Issue Date Range (дата выдачи)
- ✅ Sale Date Range (дата продажи)
- ✅ Auction Date (дата аукциона)

### 🎨 Дополнительные:
- ✅ Has Images (с фотографиями)
- ✅ Is Featured (избранные)
- ✅ In Stock (в наличии)
- ✅ Condition (состояние)
- ✅ Tags (теги)

---

## 📱 6. НАВИГАЦИЯ ПО РАЗДЕЛАМ

### 🏠 Главная
```
Главная
├── Быстрые действия
├── Поиск закладных → Маркетплейс
├── AI Анализ → AI Советник
├── Мой портфель → Портфель
└── Обучение
```

### 🛒 Маркетплейс
```
Маркетплейс
├── Поиск (текстовый)
├── 🔍 Advanced Search
│   ├── Location filters
│   ├── Financial filters
│   └── Property filters
├── Категории (States)
├── Grid/List view toggle
└── Результаты с pagination
```

### 📊 Портфель
```
Портфель
├── Overview (обзор)
│   ├── Total Invested
│   ├── Current Value
│   ├── ROI
│   └── Monthly Income
├── My Liens (мои закладные)
├── Favorites (избранное)
└── Statistics (статистика)
    ├── Status Statistics
    ├── Performance Chart
    ├── County Distribution
    └── Top Performers
```

### 🤖 AI Советник
```
AI Советник
├── Investment Recommendations
├── Risk Analysis
├── Market Trends
├── Portfolio Optimization
└── Competitor Analysis
```

### 👤 Профиль
```
Профиль
├── Личные данные
├── 📊 Данные приложения → Исторические данные
├── 🗺️ Выбор штатов → Выбор .rada файлов
├── 🔄 Управление синхронизацией → Schedules
└── Помощь
```

---

## 🔍 7. ПРИМЕРЫ ИСПОЛЬЗОВАНИЯ ФИЛЬТРОВ

### Пример 1: Найти дешевые участки в Florida без закладных

```
1. Маркетплейс → Advanced Search
2. Configure:
   - Location: State = "FL"
   - Financial: Max Tax Amount = 5000
   - Property: Status = "Available"
3. Apply
✅ Результат: Участки во Florida до $5,000 без активных закладных
```

### Пример 2: Высокодоходные закладные в Polk County

```
1. Маркетплейс → Advanced Search
2. Configure:
   - Location: State = "FL", County = "Polk"
   - Financial: Min Interest Rate = 15%
   - Property: Status = "Active"
3. Apply
✅ Результат: Активные закладные в Polk County со ставкой >15%
```

### Пример 3: Коммерческая недвижимость с высокой оценкой

```
1. Маркетплейс → Advanced Search
2. Configure:
   - Property: Type = "Commercial"
   - Financial: Min Assessed Value = 500000
   - Property: Status = "Available"
3. Apply
✅ Результат: Коммерческие объекты >$500K
```

### Пример 4: Исторические данные за 2024 год

```
1. Маркетплейс → Advanced Search
2. Configure:
   - Status: Any (любой)
   - Issue Date: 
     - Min: 01/01/2024
     - Max: 12/31/2024
3. Apply
✅ Результат: Все закладные выданные в 2024
```

---

## 📈 8. СТАТИСТИКА И АНАЛИТИКА

### A) В разделе "Портфель"

**Что доступно:**

1. **Overview Card:**
   - 💰 Total Invested (всего инвестировано)
   - 📈 Total Return (общий доход)
   - 📊 ROI % (возврат инвестиций)
   - 📅 Monthly Income (месячный доход)
   - 💼 Active Investments (активных инвестиций)

2. **Performance Chart:**
   - График доходности по времени
   - Сравнение с прошлыми периодами
   - Тренды

3. **Distribution Charts:**
   - Распределение по counties
   - Распределение по рискам
   - Диверсификация портфеля

4. **Statistics Tab:**
   - По статусам (Active, Redeemed, Foreclosed)
   - Top performing liens
   - Worst performing liens
   - Средние показатели

### B) Статистика по конкурентам

**Где найти:**

#### Вариант 1: AI Советник
```
AI Советник → Market Analysis
```

**Показывает:**
- 🏆 Top investors в выбранном регионе
- 📊 Average investor activity
- 💹 Market competition level
- 🎯 Investment strategies analysis

#### Вариант 2: Market Insights (в портфеле)
```
Портфель → Market Insights Card
```

**Данные:**
- Общее количество активных инвесторов
- Средний размер портфеля
- Популярные counties
- Тренды покупок

### C) Исторические данные

**3 источника:**

#### 1. Preload Info Screen
```
Профиль → Данные приложения
```

Показывает:
```
📊 Historical Collections (2024):
├── Polk County, FL
│   ├── Total liens: 1,250
│   ├── Total value: $1,850,000
│   ├── Avg interest: 18%
│   └── Collection date: 2024-01-10
├── Dixie County, FL
│   ├── Total liens: 850
│   ├── Total value: $1,020,000
│   └── ...
└── Putnam County, FL
    └── ...

📋 Sample Tax Liens:
├── Lien #1 - Polk County
├── Lien #2 - Dixie County
└── ...
```

#### 2. Advanced Search с датами
```
Маркетплейс → Advanced Search → Date Filters
```

Фильтры:
- Min/Max Issue Date
- Min/Max Sale Date
- Collection Year

#### 3. Portfolio Statistics
```
Портфель → Statistics Tab
```

История:
- Monthly returns (помесячная доходность)
- Historical performance
- Redemption history
- Foreclosure history

---

## 🎯 9. ПОДРОБНЫЕ СЦЕНАРИИ ИСПОЛЬЗОВАНИЯ

### Сценарий A: Инвестор ищет свободные участки

**Цель:** Найти участки в Florida без закладных, недорогие

**Действия:**
```
1. Маркетплейс
2. 🔍 Advanced Search
3. Configure:
   - Location Tab:
     ✓ State: FL
   - Financial Tab:
     ✓ Max Tax Amount: $3,000
     ✓ Min Interest Rate: 16%
   - Property Tab:
     ✓ Status: Available
     ✓ Property Type: Residential
4. Apply
```

**Результат:** Список residential участков во Florida до $3,000 без активных закладных с процентной ставкой от 16%

### Сценарий B: Анализ конкуренции в округе

**Цель:** Понять уровень конкуренции в Polk County

**Действия:**
```
1. Маркетплейс → Advanced Search
2. Location: County = "Polk"
3. Status: "Sold" (проданные)
4. Посмотреть количество результатов
5. Перейти в Портфель → Statistics
6. Проверить "Top Investors" в этом округе
7. AI Советник → Market Analysis
8. Посмотреть "Competition Level"
```

**Результат:** 
- Количество проданных закладных
- Активные инвесторы
- Уровень конкуренции
- Средние цены

### Сценарий C: Исследование исторических трендов

**Цель:** Понять динамику рынка за 2024

**Действия:**
```
1. Профиль → Данные приложения
   → Посмотреть Historical Collections (2024)
   
2. Маркетплейс → Advanced Search
   → Issue Date: 01/01/2024 - 12/31/2024
   → Получить все закладные за год
   
3. Портфель → Statistics
   → Monthly Returns chart
   → Посмотреть тренды
   
4. AI Советник → Market Trends
   → Получить AI анализ трендов
```

**Результат:**
- Исторические данные за 2024
- Тренды по месяцам
- AI прогнозы
- Сравнительная аналитика

---

## 🔍 10. РАСШИРЕННАЯ ФИЛЬТРАЦИЯ - ПОЛНЫЙ СПИСОК

### Advanced Search Filters:

#### 📍 Location (Локация)
```
├── State (штат)          → FL, AZ, CA, TX, NY...
├── County (округ)        → Polk, Miami-Dade...
├── City (город)          → Miami, Phoenix...
└── ZIP Code              → 33101, 85001...
```

#### 💰 Financial (Финансовые)
```
├── Tax Amount            → $500 - $50,000
├── Interest Rate         → 5% - 25%
├── Assessed Value        → $10,000 - $1,000,000
├── Price Range           → Min/Max
└── In Stock              → Yes/No
```

#### 🏡 Property (Недвижимость)
```
├── Property Type         → Residential, Commercial, Industrial
├── Lot Size              → 1,000 - 50,000 sq ft
├── Bedrooms              → 1 - 10+
├── Bathrooms             → 1 - 5+
├── Status                → Available, Active, Sold, Redeemed
├── Has Images            → Yes/No
├── Is Featured           → Yes/No
└── Condition             → Good, Fair, Poor
```

#### 📅 Dates (Даты)
```
├── Issue Date Range      → От - До
├── Sale Date Range       → От - До
└── Auction Date          → Конкретная дата
```

---

## 📊 11. ТИПЫ СТАТИСТИКИ

### A) Personal Statistics (Ваша статистика)

**Где:** `Портфель → Statistics Tab`

```
📊 Overall Statistics:
├── Total Invested        → Всего инвестировано
├── Current Value         → Текущая стоимость
├── Profit/Loss           → Прибыль/Убыток
├── ROI %                 → Возврат инвестиций
└── Monthly Income        → Месячный доход

📈 Status Statistics:
├── Active Liens          → Активные закладные
├── Redeemed Liens        → Погашенные
├── Foreclosed Liens      → Взысканные
└── Total Liens           → Всего закладных

📉 Performance:
├── Monthly Returns       → График по месяцам
├── YTD Performance       → За текущий год
└── All Time              → За все время
```

### B) Market Statistics (Рыночная статистика)

**Где:** `AI Советник → Market Analysis`

```
🌐 Market Overview:
├── Total Market Size     → Объем рынка
├── Active Investors      → Активные инвесторы
├── Average Yields        → Средняя доходность
└── Competition Level     → Уровень конкуренции

📍 By Location:
├── Top States            → Популярные штаты
├── Top Counties          → Популярные округа
├── Avg Prices by State   → Средние цены
└── Yields by Location    → Доходность по локации

⏱️ Trends:
├── Price Trends          → Тренды цен
├── Volume Trends         → Тренды объемов
├── Yield Trends          → Тренды доходности
└── Forecasts             → Прогнозы
```

### C) Historical Statistics (Исторические)

**Где:** `Профиль → Данные приложения`

```
📜 2024 Collections:
├── Polk County
│   ├── 1,250 liens
│   ├── $1.85M total
│   └── 18% avg rate
├── Dixie County
│   ├── 850 liens
│   ├── $1.02M total
│   └── 18% avg rate
└── Putnam County
    ├── 1,100 liens
    ├── $1.82M total
    └── 18% avg rate

📊 Historical Trends:
├── Year over year growth
├── Redemption rates
├── Foreclosure rates
└── Average returns
```

---

## 🎓 12. ПРАКТИЧЕСКИЕ ПРИМЕРЫ

### Пример 1: "Хочу инвестировать $10,000 в Florida"

**План действий:**
```
1. Профиль → Выбор штатов
   └── Выбрать "Florida" (экономия памяти)

2. Маркетплейс → Advanced Search
   └── Configure:
       - State: FL
       - Max Tax Amount: $10,000
       - Status: Available
       - Min Interest Rate: 15%

3. Посмотреть результаты

4. AI Советник → Risk Analysis
   └── Получить рекомендации по выбранным liens

5. Добавить в избранное лучшие варианты
```

### Пример 2: "Изучить конкурентов в Polk County"

**План действий:**
```
1. Маркетплейс → Advanced Search
   └── County: Polk, Status: Sold
   └── Посмотреть проданные за последний месяц

2. Портфель → Statistics
   └── County Distribution
   └── Увидеть активность в Polk

3. AI Советник → Market Analysis
   └── Competition Level для Polk
   └── Top Investors

4. Профиль → Данные приложения
   └── Historical Data для Polk County
   └── Тренды за 2024
```

### Пример 3: "Найти высокорисковые, высокодоходные возможности"

**План действий:**
```
1. Маркетплейс → Advanced Search
   └── Configure:
       - Min Interest Rate: 20%
       - Max Assessed Value: $50,000
       - Status: Available
       - Property Type: Vacant Land

2. AI Советник → Risk Analysis
   └── Каждый найденный lien
   └── Получить risk score

3. Сравнить с Historical Data
   └── Посмотреть redemption rates
   └── Для похожих liens
```

---

## 💡 13. СОВЕТЫ И ТРЮКИ

### Быстрая фильтрация:
1. **Используйте текстовый поиск** для быстрого поиска по адресу или parcel ID
2. **Advanced Search** для детальных критериев
3. **Избранное** для отслеживания интересных liens
4. **Сортировка** по цене, дате, процентной ставке

### Экономия данных:
1. **Выберите конкретные штаты** вместо "All"
2. **Используйте pagination** вместо загрузки всего
3. **Кешируйте** результаты поиска

### Анализ рынка:
1. **Проверяйте Historical Data** перед покупкой
2. **Используйте AI Советник** для рекомендаций
3. **Отслеживайте Competition Level** в выбранном county
4. **Сравнивайте** средние показатели

---

## 🚀 14. БЫСТРЫЙ СТАРТ

### Для новых пользователей:

```
День 1:
1. Профиль → Выбор штатов
   └── Выбрать интересующие штаты
   
2. Маркетплейс
   └── Изучить доступные закладные
   
3. AI Советник
   └── Получить обучающие материалы

День 2:
1. Advanced Search
   └── Настроить фильтры под свои критерии
   
2. Добавить в избранное
   └── Интересные liens

День 3:
1. Анализ через AI
   └── Риски и доходность
   
2. Первая покупка
   └── С низким риском

Далее:
1. Портфель → Statistics
   └── Отслеживать доходность
   
2. Управление синхронизацией
   └── Автоматические обновления
```

---

## 📞 15. ГДЕ НАЙТИ

### Быстрая справка:

| Что нужно | Где найти |
|-----------|-----------|
| Участки БЕЗ закладных | Маркетплейс → Advanced Search → Status: Available |
| Участки С закладными | Маркетплейс → Advanced Search → Status: Active/Sold |
| Статистика по конкурентам | AI Советник → Market Analysis |
| Исторические данные | Профиль → Данные приложения |
| Выбор штатов | Профиль → Выбор штатов |
| Управление синхронизацией | Профиль → Управление синхронизацией |
| Мои инвестиции | Портфель → My Liens |
| Статистика портфеля | Портфель → Statistics |
| AI рекомендации | AI Советник |
| Детальный поиск | Маркетплейс → 🔍 Advanced Search |

---

## ✅ Готово!

Приложение предоставляет **полный набор инструментов** для:
- ✅ Поиска участков с и без закладных
- ✅ Анализа конкуренции
- ✅ Изучения исторических данных
- ✅ Настройки персонализированной загрузки данных
- ✅ Автоматической синхронизации

**Приятного использования TaxLien.online!** 🎉

