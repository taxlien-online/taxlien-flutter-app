# Инструкция по использованию экспорта

## Быстрый старт

### 1. Установка зависимостей

**Внимание**: Если есть проблемы с flutter_yuku, временно закомментируйте эту зависимость в `pubspec.yaml`:

```yaml
dependency_overrides:
  # flutter_yuku:
  #   path: ../flutter_yuku
```

Затем:
```bash
cd taxlien-app
flutter pub get
```

### 2. Использование в приложении

1. Откройте приложение
2. Перейдите на экран **Advanced Search**
3. Выполните поиск (или используйте существующие результаты)
4. Нажмите кнопку **фильтра** (иконка фильтра) в AppBar
5. Появятся фильтры "Sean's Criteria":
   - **Budget Range**: $200 - $2000 (настраивается слайдером)
   - **Prefer Coastal Counties**: чекбокс
   - **Prefer Florida**: чекбокс  
   - **Lien Type**: выпадающий список (OTP / Auction / All)
6. Нажмите кнопку **экспорта** (иконка download) в AppBar
7. Выберите "Share" для отправки файла

### 3. Результат

Файл будет сохранен с именем:
- `sean_otp_list_2025-11-04.csv` - для OTP liens
- `sean_auction_list_2025-11-04.csv` - для аукционных liens
- `sean_all_list_2025-11-04.csv` - для всех типов

## Структура данных в CSV

| Колонка | Описание |
|---------|----------|
| Parcel ID | ID участка |
| County | Округ |
| State | Штат |
| Address | Адрес |
| City | Город |
| Zip Code | Почтовый индекс |
| Tax Amount | Сумма налога |
| Interest Rate (%) | Процентная ставка |
| Assessed Value | Оценочная стоимость |
| Estimated Value | Расчетная стоимость |
| Property Type | Тип недвижимости |
| Owner | Владелец |
| Auction Date | Дата аукциона |
| Status | Статус |
| Location Type | Coastal/Inland |
| Redemption Deadline | Срок погашения |
| Years Delinquent | Лет просрочки |

## Критерии фильтрации

1. **Бюджет**: $200 - $2000 (по умолчанию)
2. **Штат**: Флорида (если включено)
3. **Тип**: 
   - **OTP** - доступны для покупки прямо сейчас
   - **Auction** - требуют подготовки к аукциону
4. **Приоритет сортировки**:
   - Прибрежные округа (Coastal)
   - Высокая процентная ставка
   - Меньшая сумма

## Прибрежные округа

Автоматически определяются как прибрежные:
Monroe, Miami-Dade, Broward, Palm Beach, Martin, St. Lucie, Indian River, Brevard, Volusia, Flagler, St. Johns, Duval, Nassau, Escambia, Santa Rosa, Okaloosa, Walton, Bay, Franklin, Gulf, Pinellas, Hillsborough, Manatee, Sarasota, Charlotte, Lee, Collier

## Ограничения

- Экспортируется максимум 108 записей (как требовал Шон)
- Если данных меньше 108, экспортируются все доступные
- Файлы сохраняются в Documents directory приложения
- Для экспорта из Magento products (Modern tab) нужно дополнительно доработать

## Troubleshooting

### Проблема: "Package csv not found"
**Решение**: Убедитесь, что выполнили `flutter pub get`

### Проблема: "No liens match Sean's criteria"
**Решение**: 
- Убедитесь, что есть данные в результатах поиска
- Расширьте диапазон бюджета
- Отключите фильтр "Prefer Florida", если нужны другие штаты

### Проблема: "Export failed"
**Решение**:
- Проверьте разрешения на запись файлов (для Android)
- Убедитесь, что есть достаточно места на диске

