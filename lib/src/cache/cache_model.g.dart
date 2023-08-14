// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cache_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetApiCacheCollection on Isar {
  IsarCollection<ApiCache> get apiCaches => this.collection();
}

const ApiCacheSchema = CollectionSchema(
  name: r'ApiCache',
  id: -1749736005945879971,
  properties: {
    r'bodyHash': PropertySchema(
      id: 0,
      name: r'bodyHash',
      type: IsarType.long,
    ),
    r'data': PropertySchema(
      id: 1,
      name: r'data',
      type: IsarType.string,
    ),
    r'expires': PropertySchema(
      id: 2,
      name: r'expires',
      type: IsarType.dateTime,
    ),
    r'headers': PropertySchema(
      id: 3,
      name: r'headers',
      type: IsarType.string,
    ),
    r'key': PropertySchema(
      id: 4,
      name: r'key',
      type: IsarType.string,
    ),
    r'schemeName': PropertySchema(
      id: 5,
      name: r'schemeName',
      type: IsarType.string,
    ),
    r'statusCode': PropertySchema(
      id: 6,
      name: r'statusCode',
      type: IsarType.long,
    )
  },
  estimateSize: _apiCacheEstimateSize,
  serialize: _apiCacheSerialize,
  deserialize: _apiCacheDeserialize,
  deserializeProp: _apiCacheDeserializeProp,
  idName: r'id',
  indexes: {
    r'schemeName': IndexSchema(
      id: -6267973034041426503,
      name: r'schemeName',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'schemeName',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'bodyHash': IndexSchema(
      id: 20557720831322319,
      name: r'bodyHash',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'bodyHash',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _apiCacheGetId,
  getLinks: _apiCacheGetLinks,
  attach: _apiCacheAttach,
  version: '3.1.0+1',
);

int _apiCacheEstimateSize(
  ApiCache object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.data;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.headers.length * 3;
  bytesCount += 3 + object.key.length * 3;
  bytesCount += 3 + object.schemeName.length * 3;
  return bytesCount;
}

void _apiCacheSerialize(
  ApiCache object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.bodyHash);
  writer.writeString(offsets[1], object.data);
  writer.writeDateTime(offsets[2], object.expires);
  writer.writeString(offsets[3], object.headers);
  writer.writeString(offsets[4], object.key);
  writer.writeString(offsets[5], object.schemeName);
  writer.writeLong(offsets[6], object.statusCode);
}

ApiCache _apiCacheDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ApiCache();
  object.bodyHash = reader.readLongOrNull(offsets[0]);
  object.data = reader.readStringOrNull(offsets[1]);
  object.expires = reader.readDateTime(offsets[2]);
  object.headers = reader.readString(offsets[3]);
  object.id = id;
  object.key = reader.readString(offsets[4]);
  object.schemeName = reader.readString(offsets[5]);
  object.statusCode = reader.readLongOrNull(offsets[6]);
  return object;
}

P _apiCacheDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _apiCacheGetId(ApiCache object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _apiCacheGetLinks(ApiCache object) {
  return [];
}

void _apiCacheAttach(IsarCollection<dynamic> col, Id id, ApiCache object) {
  object.id = id;
}

extension ApiCacheQueryWhereSort on QueryBuilder<ApiCache, ApiCache, QWhere> {
  QueryBuilder<ApiCache, ApiCache, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterWhere> anyBodyHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'bodyHash'),
      );
    });
  }
}

extension ApiCacheQueryWhere on QueryBuilder<ApiCache, ApiCache, QWhereClause> {
  QueryBuilder<ApiCache, ApiCache, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterWhereClause> schemeNameEqualTo(
      String schemeName) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'schemeName',
        value: [schemeName],
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterWhereClause> schemeNameNotEqualTo(
      String schemeName) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'schemeName',
              lower: [],
              upper: [schemeName],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'schemeName',
              lower: [schemeName],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'schemeName',
              lower: [schemeName],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'schemeName',
              lower: [],
              upper: [schemeName],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterWhereClause> bodyHashIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'bodyHash',
        value: [null],
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterWhereClause> bodyHashIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'bodyHash',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterWhereClause> bodyHashEqualTo(
      int? bodyHash) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'bodyHash',
        value: [bodyHash],
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterWhereClause> bodyHashNotEqualTo(
      int? bodyHash) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bodyHash',
              lower: [],
              upper: [bodyHash],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bodyHash',
              lower: [bodyHash],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bodyHash',
              lower: [bodyHash],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bodyHash',
              lower: [],
              upper: [bodyHash],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterWhereClause> bodyHashGreaterThan(
    int? bodyHash, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'bodyHash',
        lower: [bodyHash],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterWhereClause> bodyHashLessThan(
    int? bodyHash, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'bodyHash',
        lower: [],
        upper: [bodyHash],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterWhereClause> bodyHashBetween(
    int? lowerBodyHash,
    int? upperBodyHash, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'bodyHash',
        lower: [lowerBodyHash],
        includeLower: includeLower,
        upper: [upperBodyHash],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ApiCacheQueryFilter
    on QueryBuilder<ApiCache, ApiCache, QFilterCondition> {
  QueryBuilder<ApiCache, ApiCache, QAfterFilterCondition> bodyHashIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'bodyHash',
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterFilterCondition> bodyHashIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'bodyHash',
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterFilterCondition> bodyHashEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bodyHash',
        value: value,
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterFilterCondition> bodyHashGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bodyHash',
        value: value,
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterFilterCondition> bodyHashLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bodyHash',
        value: value,
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterFilterCondition> bodyHashBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bodyHash',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterFilterCondition> dataIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'data',
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterFilterCondition> dataIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'data',
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterFilterCondition> dataEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'data',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterFilterCondition> dataGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'data',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterFilterCondition> dataLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'data',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterFilterCondition> dataBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'data',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterFilterCondition> dataStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'data',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterFilterCondition> dataEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'data',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterFilterCondition> dataContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'data',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterFilterCondition> dataMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'data',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterFilterCondition> dataIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'data',
        value: '',
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterFilterCondition> dataIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'data',
        value: '',
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterFilterCondition> expiresEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'expires',
        value: value,
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterFilterCondition> expiresGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'expires',
        value: value,
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterFilterCondition> expiresLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'expires',
        value: value,
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterFilterCondition> expiresBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'expires',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterFilterCondition> headersEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'headers',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterFilterCondition> headersGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'headers',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterFilterCondition> headersLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'headers',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterFilterCondition> headersBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'headers',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterFilterCondition> headersStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'headers',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterFilterCondition> headersEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'headers',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterFilterCondition> headersContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'headers',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterFilterCondition> headersMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'headers',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterFilterCondition> headersIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'headers',
        value: '',
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterFilterCondition> headersIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'headers',
        value: '',
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterFilterCondition> keyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterFilterCondition> keyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterFilterCondition> keyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterFilterCondition> keyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'key',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterFilterCondition> keyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterFilterCondition> keyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterFilterCondition> keyContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterFilterCondition> keyMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'key',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterFilterCondition> keyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'key',
        value: '',
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterFilterCondition> keyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'key',
        value: '',
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterFilterCondition> schemeNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'schemeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterFilterCondition> schemeNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'schemeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterFilterCondition> schemeNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'schemeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterFilterCondition> schemeNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'schemeName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterFilterCondition> schemeNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'schemeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterFilterCondition> schemeNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'schemeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterFilterCondition> schemeNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'schemeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterFilterCondition> schemeNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'schemeName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterFilterCondition> schemeNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'schemeName',
        value: '',
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterFilterCondition>
      schemeNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'schemeName',
        value: '',
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterFilterCondition> statusCodeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'statusCode',
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterFilterCondition>
      statusCodeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'statusCode',
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterFilterCondition> statusCodeEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'statusCode',
        value: value,
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterFilterCondition> statusCodeGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'statusCode',
        value: value,
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterFilterCondition> statusCodeLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'statusCode',
        value: value,
      ));
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterFilterCondition> statusCodeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'statusCode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ApiCacheQueryObject
    on QueryBuilder<ApiCache, ApiCache, QFilterCondition> {}

extension ApiCacheQueryLinks
    on QueryBuilder<ApiCache, ApiCache, QFilterCondition> {}

extension ApiCacheQuerySortBy on QueryBuilder<ApiCache, ApiCache, QSortBy> {
  QueryBuilder<ApiCache, ApiCache, QAfterSortBy> sortByBodyHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bodyHash', Sort.asc);
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterSortBy> sortByBodyHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bodyHash', Sort.desc);
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterSortBy> sortByData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'data', Sort.asc);
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterSortBy> sortByDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'data', Sort.desc);
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterSortBy> sortByExpires() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expires', Sort.asc);
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterSortBy> sortByExpiresDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expires', Sort.desc);
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterSortBy> sortByHeaders() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'headers', Sort.asc);
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterSortBy> sortByHeadersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'headers', Sort.desc);
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterSortBy> sortByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.asc);
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterSortBy> sortByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.desc);
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterSortBy> sortBySchemeName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'schemeName', Sort.asc);
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterSortBy> sortBySchemeNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'schemeName', Sort.desc);
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterSortBy> sortByStatusCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusCode', Sort.asc);
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterSortBy> sortByStatusCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusCode', Sort.desc);
    });
  }
}

extension ApiCacheQuerySortThenBy
    on QueryBuilder<ApiCache, ApiCache, QSortThenBy> {
  QueryBuilder<ApiCache, ApiCache, QAfterSortBy> thenByBodyHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bodyHash', Sort.asc);
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterSortBy> thenByBodyHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bodyHash', Sort.desc);
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterSortBy> thenByData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'data', Sort.asc);
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterSortBy> thenByDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'data', Sort.desc);
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterSortBy> thenByExpires() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expires', Sort.asc);
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterSortBy> thenByExpiresDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expires', Sort.desc);
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterSortBy> thenByHeaders() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'headers', Sort.asc);
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterSortBy> thenByHeadersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'headers', Sort.desc);
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterSortBy> thenByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.asc);
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterSortBy> thenByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.desc);
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterSortBy> thenBySchemeName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'schemeName', Sort.asc);
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterSortBy> thenBySchemeNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'schemeName', Sort.desc);
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterSortBy> thenByStatusCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusCode', Sort.asc);
    });
  }

  QueryBuilder<ApiCache, ApiCache, QAfterSortBy> thenByStatusCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusCode', Sort.desc);
    });
  }
}

extension ApiCacheQueryWhereDistinct
    on QueryBuilder<ApiCache, ApiCache, QDistinct> {
  QueryBuilder<ApiCache, ApiCache, QDistinct> distinctByBodyHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bodyHash');
    });
  }

  QueryBuilder<ApiCache, ApiCache, QDistinct> distinctByData(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'data', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ApiCache, ApiCache, QDistinct> distinctByExpires() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'expires');
    });
  }

  QueryBuilder<ApiCache, ApiCache, QDistinct> distinctByHeaders(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'headers', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ApiCache, ApiCache, QDistinct> distinctByKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'key', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ApiCache, ApiCache, QDistinct> distinctBySchemeName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'schemeName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ApiCache, ApiCache, QDistinct> distinctByStatusCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'statusCode');
    });
  }
}

extension ApiCacheQueryProperty
    on QueryBuilder<ApiCache, ApiCache, QQueryProperty> {
  QueryBuilder<ApiCache, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ApiCache, int?, QQueryOperations> bodyHashProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bodyHash');
    });
  }

  QueryBuilder<ApiCache, String?, QQueryOperations> dataProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'data');
    });
  }

  QueryBuilder<ApiCache, DateTime, QQueryOperations> expiresProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'expires');
    });
  }

  QueryBuilder<ApiCache, String, QQueryOperations> headersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'headers');
    });
  }

  QueryBuilder<ApiCache, String, QQueryOperations> keyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'key');
    });
  }

  QueryBuilder<ApiCache, String, QQueryOperations> schemeNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'schemeName');
    });
  }

  QueryBuilder<ApiCache, int?, QQueryOperations> statusCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'statusCode');
    });
  }
}
