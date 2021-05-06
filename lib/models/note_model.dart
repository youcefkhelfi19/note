final String tableNotes = 'notes';
class NoteFields{
  static final List<String> values= [id,isImportant,title,description,number,time];
  static final String id = '_id';
  static final String isImportant = 'isImportant';
  static final String number = 'number';
  static final String title = 'title' ;
  static final String description = 'description';
  static final String time = 'time';
}

class Note{
  final int id ;
  final String title;
  final bool isImportant ;
  final int number ;
  final description ;
  final DateTime createdTime ;

  Note(
      {this.id,
      this.title,
      this.isImportant,
      this.number,
      this.description,
      this.createdTime});
  Map<String , Object>toJson()=>{
    NoteFields.id : id,
    NoteFields.title : title ,
    NoteFields.description : description,
    NoteFields.number : number,
    NoteFields.isImportant : isImportant? 1 : 0,
    NoteFields.time : createdTime.toIso8601String(),

  };
  static Note fromJson(Map<String , Object> json)=>Note(
    id: json[NoteFields.id] as int ,
    title: json[NoteFields.title] as String ,
    description: json[NoteFields.description] as String ,
    isImportant: json[NoteFields.id] == 1 ,
    createdTime: DateTime.parse(json[NoteFields.time] as String),

  );
Note copy({int id ,
   String title,
   bool isImportant ,
   int number ,
   description ,
   DateTime createdTime ,
}){
 return Note(id: id?? this.id,
    isImportant: isImportant?? this.isImportant,
    title: title?? this.title,
    number:  number?? this.number,
    description: description?? this.description,
    createdTime: createdTime ?? this.createdTime
  );
}
}