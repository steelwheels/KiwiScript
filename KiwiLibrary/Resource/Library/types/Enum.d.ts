declare enum LogLevel {
  warning = 2,
  nolog = 0,
  error = 1,
  detail = 4,
  debug = 3
}
declare namespace LogLevel {
  function description(param: LogLevel): string ;
}
declare enum AnimationState {
  run = 1,
  pause = 2,
  idle = 0
}
declare namespace AnimationState {
  function description(param: AnimationState): string ;
}
declare enum ValueType {
  arrayType = 11,
  boolType = 1,
  URLType = 12,
  numberType = 2,
  segmentType = 17,
  imageType = 14,
  sizeType = 7,
  nullType = 0,
  recordType = 15,
  dateType = 4,
  objectType = 16,
  rectType = 8,
  enumType = 9,
  colorType = 13,
  pointType = 6,
  dictionaryType = 10,
  rangeType = 5,
  stringType = 3
}
declare namespace ValueType {
  function description(param: ValueType): string ;
}
declare enum ExitCode {
  commaneLineError = 2,
  internalError = 1,
  exception = 4,
  noError = 0,
  syntaxError = 3
}
declare namespace ExitCode {
  function description(param: ExitCode): string ;
}
declare enum AccessType {
  append = 2,
  read = 0,
  write = 1
}
declare namespace AccessType {
  function description(param: AccessType): string ;
}
declare enum Axis {
  horizontal = 0,
  vertical = 1
}
declare namespace Axis {
  function description(param: Axis): string ;
}
declare enum FileType {
  directory = 2,
  notExist = 0,
  file = 1
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
declare enum TextAlign {
  justfied = 3,
  normal = 4,
  right = 1,
  left = 0,
  center = 2
}
declare namespace TextAlign {
  function description(param: TextAlign): string ;
}
declare enum Distribution {
  equalSpacing = 3,
  fillProportinally = 1,
  fillEqually = 2,
  fill = 0
}
declare namespace Distribution {
  function description(param: Distribution): string ;
}
declare enum Authorize {
  undetermined = 0,
  authorized = 3,
  denied = 2
}
declare namespace Authorize {
  function description(param: Authorize): string ;
}
declare enum Alignment {
  center = 3,
  trailing = 1,
  leading = 0,
  fill = 2
}
declare namespace Alignment {
  function description(param: Alignment): string ;
}
