declare enum AccessType {
  append = 2,
  read = 0,
  write = 1
}
declare namespace AccessType {
  function description(param: AccessType): string ;
}
declare enum Alignment {
  leading = 0,
  trailing = 1,
  center = 3,
  fill = 2
}
declare namespace Alignment {
  function description(param: Alignment): string ;
}
declare enum AnimationState {
  run = 1,
  idle = 0,
  pause = 2
}
declare namespace AnimationState {
  function description(param: AnimationState): string ;
}
declare enum Authorize {
  denied = 2,
  authorized = 3,
  undetermined = 0
}
declare namespace Authorize {
  function description(param: Authorize): string ;
}
declare enum Axis {
  horizontal = 0,
  vertical = 1
}
declare namespace Axis {
  function description(param: Axis): string ;
}
declare enum Distribution {
  fillEqually = 2,
  equalSpacing = 3,
  fill = 0,
  fillProportinally = 1
}
declare namespace Distribution {
  function description(param: Distribution): string ;
}
declare enum ExitCode {
  syntaxError = 3,
  exception = 4,
  commaneLineError = 2,
  noError = 0,
  internalError = 1
}
declare namespace ExitCode {
  function description(param: ExitCode): string ;
}
declare enum FileType {
  notExist = 0,
  file = 1,
  directory = 2
}
declare namespace FileType {
  function description(param: FileType): string ;
}
declare enum FontSize {
  regular = 13,
  large = 19,
  small = 11
}
declare namespace FontSize {
  function description(param: FontSize): string ;
}
declare enum LogLevel {
  warning = 2,
  error = 1,
  nolog = 0,
  debug = 3,
  detail = 4
}
declare namespace LogLevel {
  function description(param: LogLevel): string ;
}
declare enum TextAlign {
  right = 1,
  normal = 4,
  center = 2,
  left = 0,
  justfied = 3
}
declare namespace TextAlign {
  function description(param: TextAlign): string ;
}
declare enum ValueType {
  stringType = 3,
  arrayType = 11,
  boolType = 1,
  rangeType = 5,
  segmentType = 17,
  imageType = 14,
  pointType = 6,
  numberType = 2,
  sizeType = 7,
  objectType = 16,
  enumType = 9,
  nullType = 0,
  rectType = 8,
  dateType = 4,
  recordType = 15,
  dictionaryType = 10,
  URLType = 12,
  colorType = 13
}
declare namespace ValueType {
  function description(param: ValueType): string ;
}
