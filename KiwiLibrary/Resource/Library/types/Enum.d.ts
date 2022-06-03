declare enum FileType {
  directory = 2,
  notExist = 0,
  file = 1
}
declare namespace FileType {
  function description(param: FileType): string ;
}
declare enum LogLevel {
  error = 1,
  debug = 3,
  detail = 4,
  nolog = 0,
  warning = 2
}
declare namespace LogLevel {
  function description(param: LogLevel): string ;
}
declare enum ExitCode {
  exception = 4,
  internalError = 1,
  noError = 0,
  commaneLineError = 2,
  syntaxError = 3
}
declare namespace ExitCode {
  function description(param: ExitCode): string ;
}
declare enum Alignment {
  fill = 2,
  trailing = 1,
  leading = 0,
  center = 3
}
declare namespace Alignment {
  function description(param: Alignment): string ;
}
declare enum FontSize {
  regular = 13,
  large = 19,
  small = 11
}
declare namespace FontSize {
  function description(param: FontSize): string ;
}
declare enum ValueType {
  recordType = 15,
  stringType = 3,
  dateType = 4,
  arrayType = 11,
  URLType = 12,
  colorType = 13,
  imageType = 14,
  boolType = 1,
  segmentType = 17,
  objectType = 16,
  sizeType = 7,
  nullType = 0,
  numberType = 2,
  dictionaryType = 10,
  rangeType = 5,
  enumType = 9,
  rectType = 8,
  pointType = 6
}
declare namespace ValueType {
  function description(param: ValueType): string ;
}
declare enum TextAlign {
  right = 1,
  center = 2,
  left = 0,
  justfied = 3,
  normal = 4
}
declare namespace TextAlign {
  function description(param: TextAlign): string ;
}
declare enum Authorize {
  authorized = 3,
  undetermined = 0,
  denied = 2
}
declare namespace Authorize {
  function description(param: Authorize): string ;
}
declare enum AnimationState {
  pause = 2,
  idle = 0,
  run = 1
}
declare namespace AnimationState {
  function description(param: AnimationState): string ;
}
declare enum Distribution {
  fill = 0,
  equalSpacing = 3,
  fillProportinally = 1,
  fillEqually = 2
}
declare namespace Distribution {
  function description(param: Distribution): string ;
}
declare enum AccessType {
  write = 1,
  read = 0,
  append = 2
}
declare namespace AccessType {
  function description(param: AccessType): string ;
}
declare enum Axis {
  vertical = 1,
  horizontal = 0
}
declare namespace Axis {
  function description(param: Axis): string ;
}
