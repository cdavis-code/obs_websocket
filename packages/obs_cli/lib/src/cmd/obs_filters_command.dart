import 'dart:convert';

import 'package:args/command_runner.dart';
import 'package:obs_cli/obs_cli.dart';

/// Filters commands
class ObsFiltersCommand extends ObsHelperCommand {
  @override
  String get description => 'Manage source filters.';

  @override
  String get name => 'filters';

  ObsFiltersCommand() {
    addSubcommand(ObsGetSourceFilterKindListCommand());
    addSubcommand(ObsGetSourceFilterListCommand());
    addSubcommand(ObsGetSourceFilterDefaultSettingsCommand());
    addSubcommand(ObsCreateSourceFilterCommand());
    addSubcommand(ObsGetSourceFilterCommand());
    addSubcommand(ObsSetSourceFilterSettingsCommand());
    addSubcommand(ObsRemoveSourceFilterCommand());
    addSubcommand(ObsSetSourceFilterNameCommand());
    addSubcommand(ObsSetSourceFilterIndexCommand());
    addSubcommand(ObsSetSourceFilterEnabledCommand());
  }
}

/// Gets an array of all available source filter kinds.
class ObsGetSourceFilterKindListCommand extends ObsHelperCommand {
  @override
  String get description =>
      'Gets an array of all available source filter kinds.';

  @override
  String get name => 'get-source-filter-kind-list';

  @override
  Future<void> run() async {
    await initializeObs();
    final filterKinds = await obs.filters.getSourceFilterKindList();
    print(filterKinds.join('\n'));
    await obs.close();
  }
}

/// Gets an array of all of a source's filters.
class ObsGetSourceFilterListCommand extends ObsHelperCommand {
  @override
  String get description => 'Gets an array of all of a source\'s filters.';

  @override
  String get name => 'get-source-filter-list';

  ObsGetSourceFilterListCommand() {
    argParser.addOption('sourceName', help: 'Name of the source');
  }

  @override
  Future<void> run() async {
    await initializeObs();
    final sourceName = argResults!['sourceName'] as String?;
    if (sourceName == null) {
      throw UsageException('sourceName must be provided.', usage);
    }
    final filters = await obs.filters.getSourceFilterList(sourceName);
    print(const JsonEncoder.withIndent('  ').convert(filters));
    await obs.close();
  }
}

/// Gets the default settings for a filter kind.
class ObsGetSourceFilterDefaultSettingsCommand extends ObsHelperCommand {
  @override
  String get description => 'Gets the default settings for a filter kind.';

  @override
  String get name => 'get-source-filter-default-settings';

  ObsGetSourceFilterDefaultSettingsCommand() {
    argParser.addOption('filterKind', help: 'The kind of filter');
  }

  @override
  Future<void> run() async {
    await initializeObs();
    final filterKind = argResults!['filterKind'] as String?;
    if (filterKind == null) {
      throw UsageException('filterKind must be provided.', usage);
    }
    final settings = await obs.filters.getSourceFilterDefaultSettings(
      filterKind,
    );
    print(const JsonEncoder.withIndent('  ').convert(settings));
    await obs.close();
  }
}

/// Creates a new filter, adding it to the specified source.
class ObsCreateSourceFilterCommand extends ObsHelperCommand {
  @override
  String get description => 'Creates a new filter, adding it to a source.';

  @override
  String get name => 'create-source-filter';

  ObsCreateSourceFilterCommand() {
    argParser
      ..addOption('sourceName', help: 'Name of the source')
      ..addOption('filterName', help: 'Name of the new filter')
      ..addOption('filterKind', help: 'The kind of filter to create')
      ..addOption('filterSettings', help: 'JSON object of filter settings');
  }

  @override
  Future<void> run() async {
    await initializeObs();
    final sourceName = argResults!['sourceName'] as String?;
    final filterName = argResults!['filterName'] as String?;
    final filterKind = argResults!['filterKind'] as String?;
    final filterSettingsJson = argResults!['filterSettings'] as String?;

    if (sourceName == null || filterName == null || filterKind == null) {
      throw UsageException(
        'sourceName, filterName, and filterKind must be provided.',
        usage,
      );
    }

    Map<String, dynamic>? filterSettings;
    if (filterSettingsJson != null) {
      filterSettings = json.decode(filterSettingsJson) as Map<String, dynamic>;
    }

    await obs.filters.createSourceFilter(
      sourceName: sourceName,
      filterName: filterName,
      filterKind: filterKind,
      filterSettings: filterSettings,
    );
    print('Filter created');
    await obs.close();
  }
}

/// Gets the info for a specific source filter.
class ObsGetSourceFilterCommand extends ObsHelperCommand {
  @override
  String get description => 'Gets the info for a specific source filter.';

  @override
  String get name => 'get-source-filter';

  ObsGetSourceFilterCommand() {
    argParser
      ..addOption('sourceName', help: 'Name of the source')
      ..addOption('filterName', help: 'Name of the filter');
  }

  @override
  Future<void> run() async {
    await initializeObs();
    final sourceName = argResults!['sourceName'] as String?;
    final filterName = argResults!['filterName'] as String?;

    if (sourceName == null || filterName == null) {
      throw UsageException(
        'sourceName and filterName must be provided.',
        usage,
      );
    }

    final filter = await obs.filters.getSourceFilter(
      sourceName: sourceName,
      filterName: filterName,
    );
    print(const JsonEncoder.withIndent('  ').convert(filter));
    await obs.close();
  }
}

/// Sets the settings of a source filter.
class ObsSetSourceFilterSettingsCommand extends ObsHelperCommand {
  @override
  String get description => 'Sets the settings of a source filter.';

  @override
  String get name => 'set-source-filter-settings';

  ObsSetSourceFilterSettingsCommand() {
    argParser
      ..addOption('sourceName', help: 'Name of the source')
      ..addOption('filterName', help: 'Name of the filter')
      ..addOption('filterSettings', help: 'JSON object of filter settings')
      ..addFlag(
        'overlay',
        help: 'Whether to overlay settings instead of replacing',
        negatable: false,
      );
  }

  @override
  Future<void> run() async {
    await initializeObs();
    final sourceName = argResults!['sourceName'] as String?;
    final filterName = argResults!['filterName'] as String?;
    final filterSettingsJson = argResults!['filterSettings'] as String?;
    final overlay = argResults!['overlay'] as bool?;

    if (sourceName == null ||
        filterName == null ||
        filterSettingsJson == null) {
      throw UsageException(
        'sourceName, filterName, and filterSettings must be provided.',
        usage,
      );
    }

    final filterSettings =
        json.decode(filterSettingsJson) as Map<String, dynamic>;

    await obs.filters.setSourceFilterSettings(
      sourceName: sourceName,
      filterName: filterName,
      filterSettings: filterSettings,
      overlay: overlay,
    );
    print('Filter settings updated');
    await obs.close();
  }
}

/// Removes a filter from a source.
class ObsRemoveSourceFilterCommand extends ObsHelperCommand {
  @override
  String get description => 'Removes a filter from a source.';

  @override
  String get name => 'remove-source-filter';

  ObsRemoveSourceFilterCommand() {
    argParser
      ..addOption('sourceName', help: 'Name of the source')
      ..addOption('filterName', help: 'Name of the filter to remove');
  }

  @override
  Future<void> run() async {
    await initializeObs();
    final sourceName = argResults!['sourceName'] as String?;
    final filterName = argResults!['filterName'] as String?;

    if (sourceName == null || filterName == null) {
      throw UsageException(
        'sourceName and filterName must be provided.',
        usage,
      );
    }

    await obs.filters.removeSourceFilter(
      sourceName: sourceName,
      filterName: filterName,
    );
    print('Filter removed');
    await obs.close();
  }
}

/// Sets the name of a source filter (rename).
class ObsSetSourceFilterNameCommand extends ObsHelperCommand {
  @override
  String get description => 'Sets the name of a source filter (rename).';

  @override
  String get name => 'set-source-filter-name';

  ObsSetSourceFilterNameCommand() {
    argParser
      ..addOption('sourceName', help: 'Name of the source')
      ..addOption('filterName', help: 'Current name of the filter')
      ..addOption('newFilterName', help: 'New name for the filter');
  }

  @override
  Future<void> run() async {
    await initializeObs();
    final sourceName = argResults!['sourceName'] as String?;
    final filterName = argResults!['filterName'] as String?;
    final newFilterName = argResults!['newFilterName'] as String?;

    if (sourceName == null || filterName == null || newFilterName == null) {
      throw UsageException(
        'sourceName, filterName, and newFilterName must be provided.',
        usage,
      );
    }

    await obs.filters.setSourceFilterName(
      sourceName: sourceName,
      filterName: filterName,
      newFilterName: newFilterName,
    );
    print('Filter renamed');
    await obs.close();
  }
}

/// Sets the index position of a filter on a source.
class ObsSetSourceFilterIndexCommand extends ObsHelperCommand {
  @override
  String get description => 'Sets the index position of a filter on a source.';

  @override
  String get name => 'set-source-filter-index';

  ObsSetSourceFilterIndexCommand() {
    argParser
      ..addOption('sourceName', help: 'Name of the source')
      ..addOption('filterName', help: 'Name of the filter')
      ..addOption('filterIndex', help: 'New index position of the filter');
  }

  @override
  Future<void> run() async {
    await initializeObs();
    final sourceName = argResults!['sourceName'] as String?;
    final filterName = argResults!['filterName'] as String?;
    final filterIndexStr = argResults!['filterIndex'] as String?;

    if (sourceName == null || filterName == null || filterIndexStr == null) {
      throw UsageException(
        'sourceName, filterName, and filterIndex must be provided.',
        usage,
      );
    }

    final filterIndex = int.parse(filterIndexStr);

    await obs.filters.setSourceFilterIndex(
      sourceName: sourceName,
      filterName: filterName,
      filterIndex: filterIndex,
    );
    print('Filter index updated');
    await obs.close();
  }
}

/// Sets the enable state of a source filter.
class ObsSetSourceFilterEnabledCommand extends ObsHelperCommand {
  @override
  String get description => 'Sets the enable state of a source filter.';

  @override
  String get name => 'set-source-filter-enabled';

  ObsSetSourceFilterEnabledCommand() {
    argParser
      ..addOption('sourceName', help: 'Name of the source')
      ..addOption('filterName', help: 'Name of the filter')
      ..addFlag(
        'filterEnabled',
        help: 'Whether the filter is enabled',
        defaultsTo: true,
        negatable: true,
      );
  }

  @override
  Future<void> run() async {
    await initializeObs();
    final sourceName = argResults!['sourceName'] as String?;
    final filterName = argResults!['filterName'] as String?;
    final filterEnabled = argResults!['filterEnabled'] as bool?;

    if (sourceName == null || filterName == null) {
      throw UsageException(
        'sourceName and filterName must be provided.',
        usage,
      );
    }

    await obs.filters.setSourceFilterEnabled(
      sourceName: sourceName,
      filterName: filterName,
      filterEnabled: filterEnabled ?? true,
    );
    print('Filter enabled state updated');
    await obs.close();
  }
}
