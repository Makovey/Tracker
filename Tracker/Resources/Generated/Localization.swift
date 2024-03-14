// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum Localization {
  internal enum Category {
    internal enum Builder {
      internal enum ErrorLabel {
        /// Такая категория уже существует
        internal static let title = Localization.tr("Localizable", "category.builder.errorLabel.title", fallback: "Такая категория уже существует")
      }
      internal enum Screen {
        /// Новая категория
        internal static let title = Localization.tr("Localizable", "category.builder.screen.title", fallback: "Новая категория")
      }
      internal enum TextField {
        /// Введите название категории
        internal static let placeholder = Localization.tr("Localizable", "category.builder.textField.placeholder", fallback: "Введите название категории")
      }
    }
    internal enum Selector {
      internal enum EmptyState {
        /// Привычки и события можно
        /// объединить по смыслу
        internal static let title = Localization.tr("Localizable", "category.selector.emptyState.title", fallback: "Привычки и события можно\nобъединить по смыслу")
      }
      internal enum PrimaryButton {
        /// Добавить категорию
        internal static let title = Localization.tr("Localizable", "category.selector.primaryButton.title", fallback: "Добавить категорию")
      }
      internal enum Screen {
        /// Создание трекера
        internal static let title = Localization.tr("Localizable", "category.selector.screen.title", fallback: "Создание трекера")
      }
    }
  }
  internal enum Common {
    internal enum DoneButton {
      /// Готово
      internal static let title = Localization.tr("Localizable", "common.doneButton.title", fallback: "Готово")
    }
    internal enum Schedule {
      /// Расписание
      internal static let title = Localization.tr("Localizable", "common.schedule.title", fallback: "Расписание")
    }
  }
  internal enum Events {
    internal enum Builder {
      internal enum CancelButton {
        /// Отменить
        internal static let title = Localization.tr("Localizable", "events.builder.cancelButton.title", fallback: "Отменить")
      }
      internal enum CategoryCell {
        /// Категория
        internal static let title = Localization.tr("Localizable", "events.builder.categoryCell.title", fallback: "Категория")
      }
      internal enum CategorySection {
        internal enum First {
          /// Emojis
          internal static let title = Localization.tr("Localizable", "events.builder.categorySection.First.title", fallback: "Emojis")
        }
        internal enum Second {
          /// Цвет
          internal static let title = Localization.tr("Localizable", "events.builder.categorySection.Second.title", fallback: "Цвет")
        }
      }
      internal enum CreateButton {
        /// Создать
        internal static let title = Localization.tr("Localizable", "events.builder.createButton.title", fallback: "Создать")
      }
      internal enum HabitScreen {
        /// Новая привычка
        internal static let title = Localization.tr("Localizable", "events.builder.habitScreen.title", fallback: "Новая привычка")
        internal enum Edit {
          /// Редактирование привычки
          internal static let title = Localization.tr("Localizable", "events.builder.habitScreen.edit.title", fallback: "Редактирование привычки")
        }
      }
      internal enum IrregularEventScreen {
        /// Новое нерегулярное событие
        internal static let title = Localization.tr("Localizable", "events.builder.irregularEventScreen.title", fallback: "Новое нерегулярное событие")
        internal enum Edit {
          /// Редактирование нерегулярного события
          internal static let title = Localization.tr("Localizable", "events.builder.irregularEventScreen.edit.title", fallback: "Редактирование нерегулярного события")
        }
      }
      internal enum TextField {
        /// Введите название трекера
        internal static let placeholder = Localization.tr("Localizable", "events.builder.textField.placeholder", fallback: "Введите название трекера")
      }
    }
    internal enum Selector {
      internal enum HabitButton {
        /// Привычка
        internal static let title = Localization.tr("Localizable", "events.selector.habitButton.title", fallback: "Привычка")
      }
      internal enum IrregularEventButton {
        /// Нерегулярное событие
        internal static let title = Localization.tr("Localizable", "events.selector.irregularEventButton.title", fallback: "Нерегулярное событие")
      }
    }
  }
  internal enum Filters {
    internal enum All {
      /// Все трекеры
      internal static let title = Localization.tr("Localizable", "filters.all.title", fallback: "Все трекеры")
    }
    internal enum Ended {
      /// Завершенные
      internal static let title = Localization.tr("Localizable", "filters.ended.title", fallback: "Завершенные")
    }
    internal enum InProgress {
      /// Не завершенные
      internal static let title = Localization.tr("Localizable", "filters.inProgress.title", fallback: "Не завершенные")
    }
    internal enum Todays {
      /// Трекеры на сегодня
      internal static let title = Localization.tr("Localizable", "filters.todays.title", fallback: "Трекеры на сегодня")
    }
  }
  internal enum Main {
    internal enum Title {
      /// Статистика
      internal static let statistics = Localization.tr("Localizable", "main.title.statistics", fallback: "Статистика")
      /// Трекеры
      internal static let trackers = Localization.tr("Localizable", "main.title.trackers", fallback: "Трекеры")
    }
  }
  internal enum Onboarding {
    internal enum First {
      /// Отслеживайте только то, что хотите
      internal static let title = Localization.tr("Localizable", "onboarding.first.title", fallback: "Отслеживайте только то, что хотите")
    }
    internal enum PrimaryButton {
      /// Вот это технологии!
      internal static let title = Localization.tr("Localizable", "onboarding.primaryButton.title", fallback: "Вот это технологии!")
    }
    internal enum Second {
      /// Даже если это не литры воды и йога
      internal static let title = Localization.tr("Localizable", "onboarding.second.title", fallback: "Даже если это не литры воды и йога")
    }
  }
  internal enum Statistics {
    internal enum AverageValue {
      /// Среднее значение
      internal static let title = Localization.tr("Localizable", "statistics.averageValue.title", fallback: "Среднее значение")
    }
    internal enum BestPeriod {
      /// Лучший период
      internal static let title = Localization.tr("Localizable", "statistics.bestPeriod.title", fallback: "Лучший период")
    }
    internal enum EmptyState {
      /// Анализировать пока нечего
      internal static let title = Localization.tr("Localizable", "statistics.emptyState.title", fallback: "Анализировать пока нечего")
    }
    internal enum IdealDays {
      /// Идеальные дни
      internal static let title = Localization.tr("Localizable", "statistics.idealDays.title", fallback: "Идеальные дни")
    }
    internal enum TrackersCompleted {
      /// Трекеров завершено
      internal static let title = Localization.tr("Localizable", "statistics.trackersCompleted.title", fallback: "Трекеров завершено")
    }
  }
  internal enum Trackers {
    internal enum Alert {
      /// Уверены что хотите удалить трекер?
      internal static let title = Localization.tr("Localizable", "trackers.alert.title", fallback: "Уверены что хотите удалить трекер?")
      internal enum CancelAction {
        /// Отменить
        internal static let title = Localization.tr("Localizable", "trackers.alert.cancelAction.title", fallback: "Отменить")
      }
      internal enum DeleteAction {
        /// Удалить
        internal static let title = Localization.tr("Localizable", "trackers.alert.deleteAction.title", fallback: "Удалить")
      }
    }
    internal enum Category {
      /// Закрепленные
      internal static let pin = Localization.tr("Localizable", "trackers.category.pin", fallback: "Закрепленные")
    }
    internal enum Cell {
      /// дней
      internal static let subtitle = Localization.tr("Localizable", "trackers.cell.subtitle", fallback: "дней")
    }
    internal enum Context {
      /// Удалить
      internal static let delete = Localization.tr("Localizable", "trackers.context.delete", fallback: "Удалить")
      /// Редактировать
      internal static let edit = Localization.tr("Localizable", "trackers.context.edit", fallback: "Редактировать")
      /// Закрепить
      internal static let pin = Localization.tr("Localizable", "trackers.context.pin", fallback: "Закрепить")
      /// Открепить
      internal static let unpin = Localization.tr("Localizable", "trackers.context.unpin", fallback: "Открепить")
    }
    internal enum EmptyState {
      /// Что будем отслеживать?
      internal static let title = Localization.tr("Localizable", "trackers.emptyState.title", fallback: "Что будем отслеживать?")
    }
    internal enum Filter {
      /// Фильтры
      internal static let title = Localization.tr("Localizable", "trackers.filter.title", fallback: "Фильтры")
    }
    internal enum NotFoundState {
      /// Ничего не найдено
      internal static let title = Localization.tr("Localizable", "trackers.notFoundState.title", fallback: "Ничего не найдено")
    }
    internal enum SearchBar {
      /// Поиск
      internal static let placeholder = Localization.tr("Localizable", "trackers.searchBar.placeholder", fallback: "Поиск")
    }
  }
  internal enum Weekday {
    internal enum Friday {
      /// Пт
      internal static let shortTitle = Localization.tr("Localizable", "weekday.friday.shortTitle", fallback: "Пт")
      /// Пятница
      internal static let title = Localization.tr("Localizable", "weekday.friday.title", fallback: "Пятница")
    }
    internal enum Monday {
      /// Пн
      internal static let shortTitle = Localization.tr("Localizable", "weekday.monday.shortTitle", fallback: "Пн")
      /// Понедельник
      internal static let title = Localization.tr("Localizable", "weekday.monday.title", fallback: "Понедельник")
    }
    internal enum Saturday {
      /// Сб
      internal static let shortTitle = Localization.tr("Localizable", "weekday.saturday.shortTitle", fallback: "Сб")
      /// Суббота
      internal static let title = Localization.tr("Localizable", "weekday.saturday.title", fallback: "Суббота")
    }
    internal enum Sunday {
      /// Вс
      internal static let shortTitle = Localization.tr("Localizable", "weekday.sunday.shortTitle", fallback: "Вс")
      /// Воскресенье
      internal static let title = Localization.tr("Localizable", "weekday.sunday.title", fallback: "Воскресенье")
    }
    internal enum Thursday {
      /// Чт
      internal static let shortTitle = Localization.tr("Localizable", "weekday.thursday.shortTitle", fallback: "Чт")
      /// Четверг
      internal static let title = Localization.tr("Localizable", "weekday.thursday.title", fallback: "Четверг")
    }
    internal enum Tuesday {
      /// Вт
      internal static let shortTitle = Localization.tr("Localizable", "weekday.tuesday.shortTitle", fallback: "Вт")
      /// Вторник
      internal static let title = Localization.tr("Localizable", "weekday.tuesday.title", fallback: "Вторник")
    }
    internal enum Wednesday {
      /// Ср
      internal static let shortTitle = Localization.tr("Localizable", "weekday.wednesday.shortTitle", fallback: "Ср")
      /// Среда
      internal static let title = Localization.tr("Localizable", "weekday.wednesday.title", fallback: "Среда")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension Localization {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = Bundle.current.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}
