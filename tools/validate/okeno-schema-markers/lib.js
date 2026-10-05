// No-op implementations: every marker's value is read straight off the
// model's decorator arguments (see `typeSpecCompilerService.readMarker` and
// `templateTypeSpecReader.ts`), so none of them needs program state. The
// functions are named so a decorator application can be matched by
// `decorator.name`.
module.exports.$from = function $from(_context, _target, _source) {};
module.exports.$workObject = function $workObject(_context, _target, _id) {};
module.exports.$icon = function $icon(_context, _target, _url) {};
module.exports.$command = function $command(_context, _target, _id) {};
module.exports.$rest = function $rest(_context, _target, _verb, _path) {};
module.exports.$event = function $event(_context, _target, _id, _source) {};
module.exports.$restResponse = function $restResponse(_context, _target, _statusCode, _body) {};
module.exports.$actor = function $actor(_context, _target, _id, _type) {};
module.exports.$readModel = function $readModel(_context, _target) {};
