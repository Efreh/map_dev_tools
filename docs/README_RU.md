# MapDevTools

Ruby gem для разработки инструментов MapLibre GL JS стилей с расширенной фильтрацией, визуализацией рельефа и мониторингом производительности. Предназначен для бесшовной интеграции в Sinatra приложения.

[![Ruby](https://img.shields.io/badge/ruby-2.7+-red.svg)](https://ruby-lang.org)
[![Sinatra](https://img.shields.io/badge/sinatra-web_framework-lightgrey.svg)](http://sinatrarb.com/)
[![MapLibre](https://img.shields.io/badge/maplibre-gl_js-blue.svg)](https://maplibre.org/)
[![English](https://img.shields.io/badge/english-documentation-green.svg)](../README.md)

## Ключевые возможности

- **Расширенная фильтрация слоев**: Фильтрация слоев на основе метаданных с поддержкой сложных выражений фильтров
- **Визуализация рельефа**: Полная поддержка рельефа с профилями высот и генерацией изолиний
- **Мониторинг производительности**: Мониторинг FPS, использования памяти и загрузки тайлов в реальном времени
- **Интерактивная отладка**: Режимы наведения и клика для инспекции объектов
- **Интеграция с Sinatra**: Бесшовная интеграция как расширение Sinatra с вспомогательными методами
- **Обслуживание статических ресурсов**: Встроенный middleware для обслуживания JavaScript модулей без конфликтов

## Обзор архитектуры

Gem состоит из нескольких интегрированных компонентов:

### Основные компоненты

- **[Основной модуль](../lib/map_dev_tools.rb)** - Основная функциональность gem включая расширение Sinatra, Rack middleware, вспомогательные методы и автономное приложение
- **[Slim шаблоны](../lib/map_dev_tools/views/)** - HTML шаблоны для интерфейса карты
- **[JavaScript модули](../lib/map_dev_tools/public/js/)** - Клиентская логика фильтрации и рельефа

### Поток данных

1. **Интеграция Sinatra** → Регистрация расширения → Настройка опций → Использование помощников
2. **Обслуживание ресурсов** → StaticMiddleware перехватывает запросы `/js/*` → Обслуживает из gem
3. **Рендеринг карты** → Вспомогательные методы рендерят Slim шаблоны → Включают внешние зависимости
4. **Клиентское взаимодействие** → JavaScript модули обрабатывают фильтрацию и функции рельефа

## Быстрый старт

### Установка

Добавьте в ваш Gemfile:

```ruby
gem 'map_dev_tools'
```

Затем выполните:

```bash
bundle install
```

### Базовая интеграция

```ruby
require 'map_dev_tools'

class MyApp < Sinatra::Base
  register MapDevTools::Extension
  
  # Настройка опций карты
  set :map_dev_tools_options, {
    style_url: 'https://your-style-url.com/style.json',
    center: [35.15, 47.41],
    zoom: 2
  }
  
  get '/map' do
    render_map_dev_tools
  end
end
```

### Автономный сервер разработки

Gem включает полное Sinatra приложение для тестирования и разработки:

```ruby
require 'map_dev_tools'

# Запуск автономного сервера разработки
MapDevTools::App.run!
```

Это запускает полноценный веб-сервер с:
- Интерфейсом карты по адресу `http://localhost:4567/map`
- Обслуживанием JavaScript ресурсов из `/js/*`
- Всей функциональностью gem из коробки

**Как использовать со стилем:**
- Передать URL стиля как параметр: `http://localhost:4567/map?style_url=https://example.com/style.json`
- Или настроить стиль по умолчанию в опциях:
```ruby
MapDevTools::App.set :map_dev_tools_options, {
  style_url: 'https://example.com/style.json'
}
```

**Без стиля:**
- Показывает только базовые тайлы (OpenStreetMap)
- Полезно для тестирования базовой функциональности
- Без пользовательских слоев и стилизации

**Случаи использования:**
- Быстрое тестирование функциональности gem
- Разработка и отладка
- Демонстрация возможностей

## Опции конфигурации

| Опция | По умолчанию | Описание |
|-------|--------------|----------|
| `style_url` | `nil` | URL стиля MapLibre по умолчанию для загрузки |
| `external_style_url` | `nil` | Параметр внешнего URL стиля |
| `center` | `[35.15, 47.41]` | Начальные координаты центра карты |
| `zoom` | `2` | Начальный уровень масштабирования |
| `basemap_tiles` | Тайлы OpenStreetMap | Массив URL тайлов базовой карты |
| `basemap_attribution` | `'© OpenStreetMap contributors'` | Текст атрибуции базовой карты |
| `basemap_opacity` | `0.8` | Прозрачность слоя базовой карты |

**Примечание:** Версии библиотек (MapLibre GL JS 5.7.3, MapLibre Contour 0.1.0, D3.js 7)

## Справочник API

### Расширение Sinatra

```ruby
# Регистрация расширения
register MapDevTools::Extension

# Настройка опций
set :map_dev_tools_options, {
  style_url: 'https://example.com/style.json',
  center: [0, 0],
  zoom: 5
}
```

### Вспомогательные методы

| Метод | Описание | Параметры |
|-------|----------|-----------|
| `render_map_dev_tools(options = {})` | Рендеринг полного интерфейса разработки карт | `options` - Хэш переопределений конфигурации |
| `render_map_layout(options = {})` | Рендеринг только макета карты | `options` - Хэш переопределений конфигурации |
| `style_url` | Получение текущего URL стиля из параметров или опций | Нет |
| `should_show_map?` | Проверка, должна ли отображаться карта | Нет |

### Автономное приложение

```ruby
# Доступные маршруты
GET /map          # Основной интерфейс разработки карт
GET /js/:file     # Обслуживание JavaScript ресурсов
```

## Поддержка метаданных стилей

Gem поддерживает расширенную фильтрацию через метаданные стилей:

```json
{
  "metadata": {
    "filters": {
      "buildings": [
        {
          "id": "residential",
          "filter": ["==", ["get", "type"], "residential"]
        },
        {
          "id": "commercial", 
          "filter": ["==", ["get", "type"], "commercial"]
        }
      ]
    },
    "locale": {
      "en": {
        "buildings": "Buildings",
        "residential": "Residential",
        "commercial": "Commercial"
      }
    }
  }
}
```

## Поддержка рельефа

Для визуализации рельефа добавьте конфигурацию рельефа в ваш стиль:

```json
{
  "terrain": {
    "source": "terrain-source"
  },
  "sources": {
    "terrain-source": {
      "type": "raster-dem",
      "tiles": ["https://your-terrain-tiles/{z}/{x}/{y}.png"],
      "encoding": "terrarium"
    }
  }
}
```

## Мониторинг производительности

Gem включает мониторинг производительности в реальном времени:

- **FPS и время кадра**: Производительность рендеринга в реальном времени
- **Использование памяти**: Мониторинг памяти кучи JavaScript
- **Загрузка тайлов**: Количество активных тайлов и статус загрузки
- **Управление слоями**: Количество активных слоев и видимость
- **Уровень масштабирования**: Текущий уровень масштабирования карты
- **Статус рельефа**: Доступность данных рельефа

## Структура файлов

```
lib/
├── map_dev_tools.rb              # Основной модуль gem и интеграция Sinatra
└── map_dev_tools/
    ├── version.rb                # Версия gem
    ├── views/                    # Slim шаблоны
    │   ├── map.slim             # Основной интерфейс карты
    │   └── map_layout.slim      # HTML макет
    └── public/js/               # JavaScript модули
        ├── filters.js           # Логика фильтрации слоев
        └── contour.js           # Функции рельефа и изолиний
```

## Разработка

### Предварительные требования

- Ruby 2.7+
- Sinatra 2.1+
- Slim 4.1+
- Rack 2.0+

### Настройка

```bash
# Установка зависимостей
bundle install

# Запуск тестов
bundle exec rspec

# Запуск RuboCop
bundle exec rubocop

# Сборка gem
gem build map_dev_tools.gemspec
```

### Тестирование

```bash
# Запуск всех тестов
bundle exec rspec

# Запуск конкретного файла тестов
bundle exec rspec spec/map_dev_tools_spec.rb
```

## Примеры интеграции

### Базовая интеграция карты

```ruby
class MyApp < Sinatra::Base
  register MapDevTools::Extension
  
  get '/map' do
    render_map_dev_tools({
      style_url: 'https://api.maptiler.com/maps/streets/style.json?key=YOUR_KEY'
    })
  end
end
```

### Пользовательская конфигурация

```ruby
class MyApp < Sinatra::Base
  register MapDevTools::Extension
  
  configure do
    set :map_dev_tools_options, {
      center: [37.6173, 55.7558],  # Координаты Москвы
      zoom: 10,
      basemap_tiles: [
        'https://tile.openstreetmap.org/{z}/{x}/{y}.png'
      ],
      basemap_attribution: '© OpenStreetMap contributors'
    }
  end
  
  get '/map' do
    render_map_dev_tools
  end
end
```

### Множественные маршруты карт

```ruby
class MyApp < Sinatra::Base
  register MapDevTools::Extension
  
  get '/map' do
    render_map_dev_tools({
      style_url: params[:style_url]
    })
  end
  
  get '/terrain' do
    render_map_dev_tools({
      style_url: 'https://example.com/terrain-style.json'
    })
  end
end
```

## Лицензия

Этот проект лицензирован под лицензией MIT - см. файл [LICENSE](../LICENSE) для деталей.
