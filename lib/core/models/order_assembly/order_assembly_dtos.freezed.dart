// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_assembly_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AssemblyItemDto _$AssemblyItemDtoFromJson(Map<String, dynamic> json) {
  return _AssemblyItemDto.fromJson(json);
}

/// @nodoc
mixin _$AssemblyItemDto {
  /// Идентификатор строки задания
  String get lineId => throw _privateConstructorUsedError;

  /// Идентификатор товара
  int get itemId => throw _privateConstructorUsedError;

  /// Наименование товара
  String get itemName => throw _privateConstructorUsedError;

  /// Штрихкод товара
  String get barcode => throw _privateConstructorUsedError;

  /// Требуемое количество
  int get quantity => throw _privateConstructorUsedError;

  /// Фактически собранное количество
  int get collectedQuantity => throw _privateConstructorUsedError;

  /// Текущий статус позиции
  AssemblyStatus get status => throw _privateConstructorUsedError;

  /// Serializes this AssemblyItemDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AssemblyItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AssemblyItemDtoCopyWith<AssemblyItemDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AssemblyItemDtoCopyWith<$Res> {
  factory $AssemblyItemDtoCopyWith(
    AssemblyItemDto value,
    $Res Function(AssemblyItemDto) then,
  ) = _$AssemblyItemDtoCopyWithImpl<$Res, AssemblyItemDto>;
  @useResult
  $Res call({
    String lineId,
    int itemId,
    String itemName,
    String barcode,
    int quantity,
    int collectedQuantity,
    AssemblyStatus status,
  });
}

/// @nodoc
class _$AssemblyItemDtoCopyWithImpl<$Res, $Val extends AssemblyItemDto>
    implements $AssemblyItemDtoCopyWith<$Res> {
  _$AssemblyItemDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AssemblyItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lineId = null,
    Object? itemId = null,
    Object? itemName = null,
    Object? barcode = null,
    Object? quantity = null,
    Object? collectedQuantity = null,
    Object? status = null,
  }) {
    return _then(
      _value.copyWith(
            lineId: null == lineId
                ? _value.lineId
                : lineId // ignore: cast_nullable_to_non_nullable
                      as String,
            itemId: null == itemId
                ? _value.itemId
                : itemId // ignore: cast_nullable_to_non_nullable
                      as int,
            itemName: null == itemName
                ? _value.itemName
                : itemName // ignore: cast_nullable_to_non_nullable
                      as String,
            barcode: null == barcode
                ? _value.barcode
                : barcode // ignore: cast_nullable_to_non_nullable
                      as String,
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as int,
            collectedQuantity: null == collectedQuantity
                ? _value.collectedQuantity
                : collectedQuantity // ignore: cast_nullable_to_non_nullable
                      as int,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as AssemblyStatus,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AssemblyItemDtoImplCopyWith<$Res>
    implements $AssemblyItemDtoCopyWith<$Res> {
  factory _$$AssemblyItemDtoImplCopyWith(
    _$AssemblyItemDtoImpl value,
    $Res Function(_$AssemblyItemDtoImpl) then,
  ) = __$$AssemblyItemDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String lineId,
    int itemId,
    String itemName,
    String barcode,
    int quantity,
    int collectedQuantity,
    AssemblyStatus status,
  });
}

/// @nodoc
class __$$AssemblyItemDtoImplCopyWithImpl<$Res>
    extends _$AssemblyItemDtoCopyWithImpl<$Res, _$AssemblyItemDtoImpl>
    implements _$$AssemblyItemDtoImplCopyWith<$Res> {
  __$$AssemblyItemDtoImplCopyWithImpl(
    _$AssemblyItemDtoImpl _value,
    $Res Function(_$AssemblyItemDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AssemblyItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lineId = null,
    Object? itemId = null,
    Object? itemName = null,
    Object? barcode = null,
    Object? quantity = null,
    Object? collectedQuantity = null,
    Object? status = null,
  }) {
    return _then(
      _$AssemblyItemDtoImpl(
        lineId: null == lineId
            ? _value.lineId
            : lineId // ignore: cast_nullable_to_non_nullable
                  as String,
        itemId: null == itemId
            ? _value.itemId
            : itemId // ignore: cast_nullable_to_non_nullable
                  as int,
        itemName: null == itemName
            ? _value.itemName
            : itemName // ignore: cast_nullable_to_non_nullable
                  as String,
        barcode: null == barcode
            ? _value.barcode
            : barcode // ignore: cast_nullable_to_non_nullable
                  as String,
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as int,
        collectedQuantity: null == collectedQuantity
            ? _value.collectedQuantity
            : collectedQuantity // ignore: cast_nullable_to_non_nullable
                  as int,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as AssemblyStatus,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AssemblyItemDtoImpl implements _AssemblyItemDto {
  const _$AssemblyItemDtoImpl({
    required this.lineId,
    required this.itemId,
    this.itemName = '',
    this.barcode = '',
    required this.quantity,
    this.collectedQuantity = 0,
    this.status = AssemblyStatus.pending,
  });

  factory _$AssemblyItemDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$AssemblyItemDtoImplFromJson(json);

  /// Идентификатор строки задания
  @override
  final String lineId;

  /// Идентификатор товара
  @override
  final int itemId;

  /// Наименование товара
  @override
  @JsonKey()
  final String itemName;

  /// Штрихкод товара
  @override
  @JsonKey()
  final String barcode;

  /// Требуемое количество
  @override
  final int quantity;

  /// Фактически собранное количество
  @override
  @JsonKey()
  final int collectedQuantity;

  /// Текущий статус позиции
  @override
  @JsonKey()
  final AssemblyStatus status;

  @override
  String toString() {
    return 'AssemblyItemDto(lineId: $lineId, itemId: $itemId, itemName: $itemName, barcode: $barcode, quantity: $quantity, collectedQuantity: $collectedQuantity, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AssemblyItemDtoImpl &&
            (identical(other.lineId, lineId) || other.lineId == lineId) &&
            (identical(other.itemId, itemId) || other.itemId == itemId) &&
            (identical(other.itemName, itemName) ||
                other.itemName == itemName) &&
            (identical(other.barcode, barcode) || other.barcode == barcode) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.collectedQuantity, collectedQuantity) ||
                other.collectedQuantity == collectedQuantity) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    lineId,
    itemId,
    itemName,
    barcode,
    quantity,
    collectedQuantity,
    status,
  );

  /// Create a copy of AssemblyItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AssemblyItemDtoImplCopyWith<_$AssemblyItemDtoImpl> get copyWith =>
      __$$AssemblyItemDtoImplCopyWithImpl<_$AssemblyItemDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AssemblyItemDtoImplToJson(this);
  }
}

abstract class _AssemblyItemDto implements AssemblyItemDto {
  const factory _AssemblyItemDto({
    required final String lineId,
    required final int itemId,
    final String itemName,
    final String barcode,
    required final int quantity,
    final int collectedQuantity,
    final AssemblyStatus status,
  }) = _$AssemblyItemDtoImpl;

  factory _AssemblyItemDto.fromJson(Map<String, dynamic> json) =
      _$AssemblyItemDtoImpl.fromJson;

  /// Идентификатор строки задания
  @override
  String get lineId;

  /// Идентификатор товара
  @override
  int get itemId;

  /// Наименование товара
  @override
  String get itemName;

  /// Штрихкод товара
  @override
  String get barcode;

  /// Требуемое количество
  @override
  int get quantity;

  /// Фактически собранное количество
  @override
  int get collectedQuantity;

  /// Текущий статус позиции
  @override
  AssemblyStatus get status;

  /// Create a copy of AssemblyItemDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AssemblyItemDtoImplCopyWith<_$AssemblyItemDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CellPlacement _$CellPlacementFromJson(Map<String, dynamic> json) {
  return _CellPlacement.fromJson(json);
}

/// @nodoc
mixin _$CellPlacement {
  /// Идентификатор назначения (assembly assignment ID)
  String get assignmentId => throw _privateConstructorUsedError;

  /// Код ячейки (штрихкод, который сканирует работник в режиме Размещения)
  String get cellCode => throw _privateConstructorUsedError;

  /// Отображаемое название ячейки
  String get cellDisplayName => throw _privateConstructorUsedError;

  /// Список товаров, относящихся к этой ячейке
  List<AssemblyItemDto> get items => throw _privateConstructorUsedError;

  /// Serializes this CellPlacement to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CellPlacement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CellPlacementCopyWith<CellPlacement> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CellPlacementCopyWith<$Res> {
  factory $CellPlacementCopyWith(
    CellPlacement value,
    $Res Function(CellPlacement) then,
  ) = _$CellPlacementCopyWithImpl<$Res, CellPlacement>;
  @useResult
  $Res call({
    String assignmentId,
    String cellCode,
    String cellDisplayName,
    List<AssemblyItemDto> items,
  });
}

/// @nodoc
class _$CellPlacementCopyWithImpl<$Res, $Val extends CellPlacement>
    implements $CellPlacementCopyWith<$Res> {
  _$CellPlacementCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CellPlacement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? assignmentId = null,
    Object? cellCode = null,
    Object? cellDisplayName = null,
    Object? items = null,
  }) {
    return _then(
      _value.copyWith(
            assignmentId: null == assignmentId
                ? _value.assignmentId
                : assignmentId // ignore: cast_nullable_to_non_nullable
                      as String,
            cellCode: null == cellCode
                ? _value.cellCode
                : cellCode // ignore: cast_nullable_to_non_nullable
                      as String,
            cellDisplayName: null == cellDisplayName
                ? _value.cellDisplayName
                : cellDisplayName // ignore: cast_nullable_to_non_nullable
                      as String,
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<AssemblyItemDto>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CellPlacementImplCopyWith<$Res>
    implements $CellPlacementCopyWith<$Res> {
  factory _$$CellPlacementImplCopyWith(
    _$CellPlacementImpl value,
    $Res Function(_$CellPlacementImpl) then,
  ) = __$$CellPlacementImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String assignmentId,
    String cellCode,
    String cellDisplayName,
    List<AssemblyItemDto> items,
  });
}

/// @nodoc
class __$$CellPlacementImplCopyWithImpl<$Res>
    extends _$CellPlacementCopyWithImpl<$Res, _$CellPlacementImpl>
    implements _$$CellPlacementImplCopyWith<$Res> {
  __$$CellPlacementImplCopyWithImpl(
    _$CellPlacementImpl _value,
    $Res Function(_$CellPlacementImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CellPlacement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? assignmentId = null,
    Object? cellCode = null,
    Object? cellDisplayName = null,
    Object? items = null,
  }) {
    return _then(
      _$CellPlacementImpl(
        assignmentId: null == assignmentId
            ? _value.assignmentId
            : assignmentId // ignore: cast_nullable_to_non_nullable
                  as String,
        cellCode: null == cellCode
            ? _value.cellCode
            : cellCode // ignore: cast_nullable_to_non_nullable
                  as String,
        cellDisplayName: null == cellDisplayName
            ? _value.cellDisplayName
            : cellDisplayName // ignore: cast_nullable_to_non_nullable
                  as String,
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<AssemblyItemDto>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CellPlacementImpl implements _CellPlacement {
  const _$CellPlacementImpl({
    required this.assignmentId,
    required this.cellCode,
    this.cellDisplayName = '',
    final List<AssemblyItemDto> items = const [],
  }) : _items = items;

  factory _$CellPlacementImpl.fromJson(Map<String, dynamic> json) =>
      _$$CellPlacementImplFromJson(json);

  /// Идентификатор назначения (assembly assignment ID)
  @override
  final String assignmentId;

  /// Код ячейки (штрихкод, который сканирует работник в режиме Размещения)
  @override
  final String cellCode;

  /// Отображаемое название ячейки
  @override
  @JsonKey()
  final String cellDisplayName;

  /// Список товаров, относящихся к этой ячейке
  final List<AssemblyItemDto> _items;

  /// Список товаров, относящихся к этой ячейке
  @override
  @JsonKey()
  List<AssemblyItemDto> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'CellPlacement(assignmentId: $assignmentId, cellCode: $cellCode, cellDisplayName: $cellDisplayName, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CellPlacementImpl &&
            (identical(other.assignmentId, assignmentId) ||
                other.assignmentId == assignmentId) &&
            (identical(other.cellCode, cellCode) ||
                other.cellCode == cellCode) &&
            (identical(other.cellDisplayName, cellDisplayName) ||
                other.cellDisplayName == cellDisplayName) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    assignmentId,
    cellCode,
    cellDisplayName,
    const DeepCollectionEquality().hash(_items),
  );

  /// Create a copy of CellPlacement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CellPlacementImplCopyWith<_$CellPlacementImpl> get copyWith =>
      __$$CellPlacementImplCopyWithImpl<_$CellPlacementImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CellPlacementImplToJson(this);
  }
}

abstract class _CellPlacement implements CellPlacement {
  const factory _CellPlacement({
    required final String assignmentId,
    required final String cellCode,
    final String cellDisplayName,
    final List<AssemblyItemDto> items,
  }) = _$CellPlacementImpl;

  factory _CellPlacement.fromJson(Map<String, dynamic> json) =
      _$CellPlacementImpl.fromJson;

  /// Идентификатор назначения (assembly assignment ID)
  @override
  String get assignmentId;

  /// Код ячейки (штрихкод, который сканирует работник в режиме Размещения)
  @override
  String get cellCode;

  /// Отображаемое название ячейки
  @override
  String get cellDisplayName;

  /// Список товаров, относящихся к этой ячейке
  @override
  List<AssemblyItemDto> get items;

  /// Create a copy of CellPlacement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CellPlacementImplCopyWith<_$CellPlacementImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WorkerAssemblyTaskDto _$WorkerAssemblyTaskDtoFromJson(
  Map<String, dynamic> json,
) {
  return _WorkerAssemblyTaskDto.fromJson(json);
}

/// @nodoc
mixin _$WorkerAssemblyTaskDto {
  /// Уникальный ID назначения
  String get assignmentId => throw _privateConstructorUsedError;

  /// Номер задачи (отображается в списке)
  String get taskNumber => throw _privateConstructorUsedError;

  /// Дата создания задачи
  String? get createdDate => throw _privateConstructorUsedError;

  /// Список ячеек выдачи с привязанными товарами
  List<CellPlacement> get cellPlacements => throw _privateConstructorUsedError;

  /// Serializes this WorkerAssemblyTaskDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkerAssemblyTaskDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkerAssemblyTaskDtoCopyWith<WorkerAssemblyTaskDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkerAssemblyTaskDtoCopyWith<$Res> {
  factory $WorkerAssemblyTaskDtoCopyWith(
    WorkerAssemblyTaskDto value,
    $Res Function(WorkerAssemblyTaskDto) then,
  ) = _$WorkerAssemblyTaskDtoCopyWithImpl<$Res, WorkerAssemblyTaskDto>;
  @useResult
  $Res call({
    String assignmentId,
    String taskNumber,
    String? createdDate,
    List<CellPlacement> cellPlacements,
  });
}

/// @nodoc
class _$WorkerAssemblyTaskDtoCopyWithImpl<
  $Res,
  $Val extends WorkerAssemblyTaskDto
>
    implements $WorkerAssemblyTaskDtoCopyWith<$Res> {
  _$WorkerAssemblyTaskDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkerAssemblyTaskDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? assignmentId = null,
    Object? taskNumber = null,
    Object? createdDate = freezed,
    Object? cellPlacements = null,
  }) {
    return _then(
      _value.copyWith(
            assignmentId: null == assignmentId
                ? _value.assignmentId
                : assignmentId // ignore: cast_nullable_to_non_nullable
                      as String,
            taskNumber: null == taskNumber
                ? _value.taskNumber
                : taskNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            createdDate: freezed == createdDate
                ? _value.createdDate
                : createdDate // ignore: cast_nullable_to_non_nullable
                      as String?,
            cellPlacements: null == cellPlacements
                ? _value.cellPlacements
                : cellPlacements // ignore: cast_nullable_to_non_nullable
                      as List<CellPlacement>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WorkerAssemblyTaskDtoImplCopyWith<$Res>
    implements $WorkerAssemblyTaskDtoCopyWith<$Res> {
  factory _$$WorkerAssemblyTaskDtoImplCopyWith(
    _$WorkerAssemblyTaskDtoImpl value,
    $Res Function(_$WorkerAssemblyTaskDtoImpl) then,
  ) = __$$WorkerAssemblyTaskDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String assignmentId,
    String taskNumber,
    String? createdDate,
    List<CellPlacement> cellPlacements,
  });
}

/// @nodoc
class __$$WorkerAssemblyTaskDtoImplCopyWithImpl<$Res>
    extends
        _$WorkerAssemblyTaskDtoCopyWithImpl<$Res, _$WorkerAssemblyTaskDtoImpl>
    implements _$$WorkerAssemblyTaskDtoImplCopyWith<$Res> {
  __$$WorkerAssemblyTaskDtoImplCopyWithImpl(
    _$WorkerAssemblyTaskDtoImpl _value,
    $Res Function(_$WorkerAssemblyTaskDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WorkerAssemblyTaskDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? assignmentId = null,
    Object? taskNumber = null,
    Object? createdDate = freezed,
    Object? cellPlacements = null,
  }) {
    return _then(
      _$WorkerAssemblyTaskDtoImpl(
        assignmentId: null == assignmentId
            ? _value.assignmentId
            : assignmentId // ignore: cast_nullable_to_non_nullable
                  as String,
        taskNumber: null == taskNumber
            ? _value.taskNumber
            : taskNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        createdDate: freezed == createdDate
            ? _value.createdDate
            : createdDate // ignore: cast_nullable_to_non_nullable
                  as String?,
        cellPlacements: null == cellPlacements
            ? _value._cellPlacements
            : cellPlacements // ignore: cast_nullable_to_non_nullable
                  as List<CellPlacement>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkerAssemblyTaskDtoImpl implements _WorkerAssemblyTaskDto {
  const _$WorkerAssemblyTaskDtoImpl({
    required this.assignmentId,
    this.taskNumber = '',
    this.createdDate,
    final List<CellPlacement> cellPlacements = const [],
  }) : _cellPlacements = cellPlacements;

  factory _$WorkerAssemblyTaskDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkerAssemblyTaskDtoImplFromJson(json);

  /// Уникальный ID назначения
  @override
  final String assignmentId;

  /// Номер задачи (отображается в списке)
  @override
  @JsonKey()
  final String taskNumber;

  /// Дата создания задачи
  @override
  final String? createdDate;

  /// Список ячеек выдачи с привязанными товарами
  final List<CellPlacement> _cellPlacements;

  /// Список ячеек выдачи с привязанными товарами
  @override
  @JsonKey()
  List<CellPlacement> get cellPlacements {
    if (_cellPlacements is EqualUnmodifiableListView) return _cellPlacements;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cellPlacements);
  }

  @override
  String toString() {
    return 'WorkerAssemblyTaskDto(assignmentId: $assignmentId, taskNumber: $taskNumber, createdDate: $createdDate, cellPlacements: $cellPlacements)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkerAssemblyTaskDtoImpl &&
            (identical(other.assignmentId, assignmentId) ||
                other.assignmentId == assignmentId) &&
            (identical(other.taskNumber, taskNumber) ||
                other.taskNumber == taskNumber) &&
            (identical(other.createdDate, createdDate) ||
                other.createdDate == createdDate) &&
            const DeepCollectionEquality().equals(
              other._cellPlacements,
              _cellPlacements,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    assignmentId,
    taskNumber,
    createdDate,
    const DeepCollectionEquality().hash(_cellPlacements),
  );

  /// Create a copy of WorkerAssemblyTaskDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkerAssemblyTaskDtoImplCopyWith<_$WorkerAssemblyTaskDtoImpl>
  get copyWith =>
      __$$WorkerAssemblyTaskDtoImplCopyWithImpl<_$WorkerAssemblyTaskDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkerAssemblyTaskDtoImplToJson(this);
  }
}

abstract class _WorkerAssemblyTaskDto implements WorkerAssemblyTaskDto {
  const factory _WorkerAssemblyTaskDto({
    required final String assignmentId,
    final String taskNumber,
    final String? createdDate,
    final List<CellPlacement> cellPlacements,
  }) = _$WorkerAssemblyTaskDtoImpl;

  factory _WorkerAssemblyTaskDto.fromJson(Map<String, dynamic> json) =
      _$WorkerAssemblyTaskDtoImpl.fromJson;

  /// Уникальный ID назначения
  @override
  String get assignmentId;

  /// Номер задачи (отображается в списке)
  @override
  String get taskNumber;

  /// Дата создания задачи
  @override
  String? get createdDate;

  /// Список ячеек выдачи с привязанными товарами
  @override
  List<CellPlacement> get cellPlacements;

  /// Create a copy of WorkerAssemblyTaskDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkerAssemblyTaskDtoImplCopyWith<_$WorkerAssemblyTaskDtoImpl>
  get copyWith => throw _privateConstructorUsedError;
}

ScanPickRequest _$ScanPickRequestFromJson(Map<String, dynamic> json) {
  return _ScanPickRequest.fromJson(json);
}

/// @nodoc
mixin _$ScanPickRequest {
  /// ID строки задания
  String get lineId => throw _privateConstructorUsedError;

  /// Отсканированный штрихкод товара
  String get barcode => throw _privateConstructorUsedError;

  /// Serializes this ScanPickRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ScanPickRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScanPickRequestCopyWith<ScanPickRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScanPickRequestCopyWith<$Res> {
  factory $ScanPickRequestCopyWith(
    ScanPickRequest value,
    $Res Function(ScanPickRequest) then,
  ) = _$ScanPickRequestCopyWithImpl<$Res, ScanPickRequest>;
  @useResult
  $Res call({String lineId, String barcode});
}

/// @nodoc
class _$ScanPickRequestCopyWithImpl<$Res, $Val extends ScanPickRequest>
    implements $ScanPickRequestCopyWith<$Res> {
  _$ScanPickRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScanPickRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? lineId = null, Object? barcode = null}) {
    return _then(
      _value.copyWith(
            lineId: null == lineId
                ? _value.lineId
                : lineId // ignore: cast_nullable_to_non_nullable
                      as String,
            barcode: null == barcode
                ? _value.barcode
                : barcode // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ScanPickRequestImplCopyWith<$Res>
    implements $ScanPickRequestCopyWith<$Res> {
  factory _$$ScanPickRequestImplCopyWith(
    _$ScanPickRequestImpl value,
    $Res Function(_$ScanPickRequestImpl) then,
  ) = __$$ScanPickRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String lineId, String barcode});
}

/// @nodoc
class __$$ScanPickRequestImplCopyWithImpl<$Res>
    extends _$ScanPickRequestCopyWithImpl<$Res, _$ScanPickRequestImpl>
    implements _$$ScanPickRequestImplCopyWith<$Res> {
  __$$ScanPickRequestImplCopyWithImpl(
    _$ScanPickRequestImpl _value,
    $Res Function(_$ScanPickRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ScanPickRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? lineId = null, Object? barcode = null}) {
    return _then(
      _$ScanPickRequestImpl(
        lineId: null == lineId
            ? _value.lineId
            : lineId // ignore: cast_nullable_to_non_nullable
                  as String,
        barcode: null == barcode
            ? _value.barcode
            : barcode // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ScanPickRequestImpl implements _ScanPickRequest {
  const _$ScanPickRequestImpl({required this.lineId, required this.barcode});

  factory _$ScanPickRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScanPickRequestImplFromJson(json);

  /// ID строки задания
  @override
  final String lineId;

  /// Отсканированный штрихкод товара
  @override
  final String barcode;

  @override
  String toString() {
    return 'ScanPickRequest(lineId: $lineId, barcode: $barcode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScanPickRequestImpl &&
            (identical(other.lineId, lineId) || other.lineId == lineId) &&
            (identical(other.barcode, barcode) || other.barcode == barcode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, lineId, barcode);

  /// Create a copy of ScanPickRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScanPickRequestImplCopyWith<_$ScanPickRequestImpl> get copyWith =>
      __$$ScanPickRequestImplCopyWithImpl<_$ScanPickRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ScanPickRequestImplToJson(this);
  }
}

abstract class _ScanPickRequest implements ScanPickRequest {
  const factory _ScanPickRequest({
    required final String lineId,
    required final String barcode,
  }) = _$ScanPickRequestImpl;

  factory _ScanPickRequest.fromJson(Map<String, dynamic> json) =
      _$ScanPickRequestImpl.fromJson;

  /// ID строки задания
  @override
  String get lineId;

  /// Отсканированный штрихкод товара
  @override
  String get barcode;

  /// Create a copy of ScanPickRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScanPickRequestImplCopyWith<_$ScanPickRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ScanPlaceBulkRequest _$ScanPlaceBulkRequestFromJson(Map<String, dynamic> json) {
  return _ScanPlaceBulkRequest.fromJson(json);
}

/// @nodoc
mixin _$ScanPlaceBulkRequest {
  /// ID назначения (все товары этого назначения переводятся в «Размещено»)
  String get assignmentId => throw _privateConstructorUsedError;

  /// Код ячейки выдачи (результат сканирования)
  String get cellCode => throw _privateConstructorUsedError;

  /// Serializes this ScanPlaceBulkRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ScanPlaceBulkRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScanPlaceBulkRequestCopyWith<ScanPlaceBulkRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScanPlaceBulkRequestCopyWith<$Res> {
  factory $ScanPlaceBulkRequestCopyWith(
    ScanPlaceBulkRequest value,
    $Res Function(ScanPlaceBulkRequest) then,
  ) = _$ScanPlaceBulkRequestCopyWithImpl<$Res, ScanPlaceBulkRequest>;
  @useResult
  $Res call({String assignmentId, String cellCode});
}

/// @nodoc
class _$ScanPlaceBulkRequestCopyWithImpl<
  $Res,
  $Val extends ScanPlaceBulkRequest
>
    implements $ScanPlaceBulkRequestCopyWith<$Res> {
  _$ScanPlaceBulkRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScanPlaceBulkRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? assignmentId = null, Object? cellCode = null}) {
    return _then(
      _value.copyWith(
            assignmentId: null == assignmentId
                ? _value.assignmentId
                : assignmentId // ignore: cast_nullable_to_non_nullable
                      as String,
            cellCode: null == cellCode
                ? _value.cellCode
                : cellCode // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ScanPlaceBulkRequestImplCopyWith<$Res>
    implements $ScanPlaceBulkRequestCopyWith<$Res> {
  factory _$$ScanPlaceBulkRequestImplCopyWith(
    _$ScanPlaceBulkRequestImpl value,
    $Res Function(_$ScanPlaceBulkRequestImpl) then,
  ) = __$$ScanPlaceBulkRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String assignmentId, String cellCode});
}

/// @nodoc
class __$$ScanPlaceBulkRequestImplCopyWithImpl<$Res>
    extends _$ScanPlaceBulkRequestCopyWithImpl<$Res, _$ScanPlaceBulkRequestImpl>
    implements _$$ScanPlaceBulkRequestImplCopyWith<$Res> {
  __$$ScanPlaceBulkRequestImplCopyWithImpl(
    _$ScanPlaceBulkRequestImpl _value,
    $Res Function(_$ScanPlaceBulkRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ScanPlaceBulkRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? assignmentId = null, Object? cellCode = null}) {
    return _then(
      _$ScanPlaceBulkRequestImpl(
        assignmentId: null == assignmentId
            ? _value.assignmentId
            : assignmentId // ignore: cast_nullable_to_non_nullable
                  as String,
        cellCode: null == cellCode
            ? _value.cellCode
            : cellCode // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ScanPlaceBulkRequestImpl implements _ScanPlaceBulkRequest {
  const _$ScanPlaceBulkRequestImpl({
    required this.assignmentId,
    required this.cellCode,
  });

  factory _$ScanPlaceBulkRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScanPlaceBulkRequestImplFromJson(json);

  /// ID назначения (все товары этого назначения переводятся в «Размещено»)
  @override
  final String assignmentId;

  /// Код ячейки выдачи (результат сканирования)
  @override
  final String cellCode;

  @override
  String toString() {
    return 'ScanPlaceBulkRequest(assignmentId: $assignmentId, cellCode: $cellCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScanPlaceBulkRequestImpl &&
            (identical(other.assignmentId, assignmentId) ||
                other.assignmentId == assignmentId) &&
            (identical(other.cellCode, cellCode) ||
                other.cellCode == cellCode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, assignmentId, cellCode);

  /// Create a copy of ScanPlaceBulkRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScanPlaceBulkRequestImplCopyWith<_$ScanPlaceBulkRequestImpl>
  get copyWith =>
      __$$ScanPlaceBulkRequestImplCopyWithImpl<_$ScanPlaceBulkRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ScanPlaceBulkRequestImplToJson(this);
  }
}

abstract class _ScanPlaceBulkRequest implements ScanPlaceBulkRequest {
  const factory _ScanPlaceBulkRequest({
    required final String assignmentId,
    required final String cellCode,
  }) = _$ScanPlaceBulkRequestImpl;

  factory _ScanPlaceBulkRequest.fromJson(Map<String, dynamic> json) =
      _$ScanPlaceBulkRequestImpl.fromJson;

  /// ID назначения (все товары этого назначения переводятся в «Размещено»)
  @override
  String get assignmentId;

  /// Код ячейки выдачи (результат сканирования)
  @override
  String get cellCode;

  /// Create a copy of ScanPlaceBulkRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScanPlaceBulkRequestImplCopyWith<_$ScanPlaceBulkRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}

ReportMissingRequest _$ReportMissingRequestFromJson(Map<String, dynamic> json) {
  return _ReportMissingRequest.fromJson(json);
}

/// @nodoc
mixin _$ReportMissingRequest {
  /// ID строки задания с отсутствующим товаром
  String get lineId => throw _privateConstructorUsedError;

  /// Причина отсутствия
  String get reason => throw _privateConstructorUsedError;

  /// Serializes this ReportMissingRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReportMissingRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReportMissingRequestCopyWith<ReportMissingRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReportMissingRequestCopyWith<$Res> {
  factory $ReportMissingRequestCopyWith(
    ReportMissingRequest value,
    $Res Function(ReportMissingRequest) then,
  ) = _$ReportMissingRequestCopyWithImpl<$Res, ReportMissingRequest>;
  @useResult
  $Res call({String lineId, String reason});
}

/// @nodoc
class _$ReportMissingRequestCopyWithImpl<
  $Res,
  $Val extends ReportMissingRequest
>
    implements $ReportMissingRequestCopyWith<$Res> {
  _$ReportMissingRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReportMissingRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? lineId = null, Object? reason = null}) {
    return _then(
      _value.copyWith(
            lineId: null == lineId
                ? _value.lineId
                : lineId // ignore: cast_nullable_to_non_nullable
                      as String,
            reason: null == reason
                ? _value.reason
                : reason // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReportMissingRequestImplCopyWith<$Res>
    implements $ReportMissingRequestCopyWith<$Res> {
  factory _$$ReportMissingRequestImplCopyWith(
    _$ReportMissingRequestImpl value,
    $Res Function(_$ReportMissingRequestImpl) then,
  ) = __$$ReportMissingRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String lineId, String reason});
}

/// @nodoc
class __$$ReportMissingRequestImplCopyWithImpl<$Res>
    extends _$ReportMissingRequestCopyWithImpl<$Res, _$ReportMissingRequestImpl>
    implements _$$ReportMissingRequestImplCopyWith<$Res> {
  __$$ReportMissingRequestImplCopyWithImpl(
    _$ReportMissingRequestImpl _value,
    $Res Function(_$ReportMissingRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReportMissingRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? lineId = null, Object? reason = null}) {
    return _then(
      _$ReportMissingRequestImpl(
        lineId: null == lineId
            ? _value.lineId
            : lineId // ignore: cast_nullable_to_non_nullable
                  as String,
        reason: null == reason
            ? _value.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReportMissingRequestImpl implements _ReportMissingRequest {
  const _$ReportMissingRequestImpl({
    required this.lineId,
    required this.reason,
  });

  factory _$ReportMissingRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReportMissingRequestImplFromJson(json);

  /// ID строки задания с отсутствующим товаром
  @override
  final String lineId;

  /// Причина отсутствия
  @override
  final String reason;

  @override
  String toString() {
    return 'ReportMissingRequest(lineId: $lineId, reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReportMissingRequestImpl &&
            (identical(other.lineId, lineId) || other.lineId == lineId) &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, lineId, reason);

  /// Create a copy of ReportMissingRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReportMissingRequestImplCopyWith<_$ReportMissingRequestImpl>
  get copyWith =>
      __$$ReportMissingRequestImplCopyWithImpl<_$ReportMissingRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ReportMissingRequestImplToJson(this);
  }
}

abstract class _ReportMissingRequest implements ReportMissingRequest {
  const factory _ReportMissingRequest({
    required final String lineId,
    required final String reason,
  }) = _$ReportMissingRequestImpl;

  factory _ReportMissingRequest.fromJson(Map<String, dynamic> json) =
      _$ReportMissingRequestImpl.fromJson;

  /// ID строки задания с отсутствующим товаром
  @override
  String get lineId;

  /// Причина отсутствия
  @override
  String get reason;

  /// Create a copy of ReportMissingRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReportMissingRequestImplCopyWith<_$ReportMissingRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}
