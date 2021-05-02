import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _courseName;
  int _courseCredit = 1;
  double _courseScore = 4;
  List<Course> allCourses;
  var formKey = GlobalKey<FormState>();
  double average = 0;
  TextEditingController textController;
  static int counter = 0;
  var _sKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    allCourses = [];
    textController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _sKey,
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: Icon(Icons.plus_one),
        onPressed: () {
          if (formKey.currentState.validate()) {
            formKey.currentState.save();
            textController.text = "";
            _sKey.currentState.showSnackBar(SnackBar(
                backgroundColor: Colors.orange[800],
                duration: Duration(seconds: 2),
                content: Text(
                  "Course added!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                )));
          }
        },
      ),
      appBar: AppBar(
        backgroundColor: Colors.orange[800],
        title: Text("GPACalc"),
      ),
      body: appBody(),
    );
  }

  Widget appBody() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //. STATIC FORM CONTAINER
          Container(
            padding: EdgeInsets.all(10),
            color: Colors.blue[900],
            child: Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: textController,
                      style: TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value.length > 0) {
                          return null;
                        } else {
                          return "Course name cannot be blank!";
                        }
                      },
                      onSaved: (savedValue) {
                        _courseName = savedValue;
                        setState(() {
                          allCourses.add(
                              Course(_courseName, _courseScore, _courseCredit));
                          average = 0;
                          calculateAvg();
                        });
                      },
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Colors.white)),
                          hintText: "Course Name",
                          hintStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20))),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: DropdownButton<int>(
                            dropdownColor: Colors.blue[800],
                            items: courseCreditItems(),
                            value: _courseCredit,
                            onChanged: (selectedCredit) {
                              setState(() {
                                _courseCredit = selectedCredit;
                              });
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: DropdownButton<double>(
                            dropdownColor: Colors.blue[800],
                            items: courseScoresItems(),
                            value: _courseScore,
                            onChanged: (selectedCourseScore) {
                              setState(() {
                                _courseScore = selectedCourseScore;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Container(
                        height: 50,
                        decoration: BoxDecoration(
                            border: BorderDirectional(
                                top: BorderSide(
                                    color: Colors.orange[800], width: 2),
                                bottom: BorderSide(
                                    color: Colors.orange[800], width: 2))),
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: Center(
                            child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                        text: allCourses.length == 0
                                            ? ""
                                            : "Average: ",
                                        style: TextStyle(fontSize: 16)),
                                    TextSpan(
                                        text: allCourses.length == 0
                                            ? "No course added!"
                                            : "${average.toStringAsFixed(2)}",
                                        style: TextStyle(fontSize: 16)),
                                  ],
                                  //       child: Text(
                                  //     "Average: ",
                                  //     style: TextStyle(color: Colors.white),
                                  //   )),
                                  //   height: 70,
                                  // ),

                                  // Divider(
                                  //   indent: MediaQuery.of(context).size.height / 32,
                                  //   height: MediaQuery.of(context).size.height / 8,
                                  //   color: Colors.white,
                                  //   endIndent: MediaQuery.of(context).size.height / 32,
                                  // ),
                                )))),
                  ],
                )),
          ),

          //. DYNAMIC LIST CONTAINER
          Expanded(
            child: Container(
              color: Colors.blue[900],
              child: ListView.builder(
                itemBuilder: _createListElements,
                itemCount: allCourses.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<int>> courseCreditItems() {
    List<DropdownMenuItem<int>> credits = [];

    for (int i = 1; i <= 10; i++) {
      credits.add(DropdownMenuItem(
          child: Text(
            "$i credit",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          value: i));
    }
    return credits;
  }

  List<DropdownMenuItem<double>> courseScoresItems() {
    List<DropdownMenuItem<double>> courseScores = [];
    courseScores.add(DropdownMenuItem(
      child: Text("AA", style: TextStyle(color: Colors.white, fontSize: 20)),
      value: 4,
    ));
    courseScores.add(DropdownMenuItem(
      child: Text("BA", style: TextStyle(color: Colors.white, fontSize: 20)),
      value: 3.5,
    ));
    courseScores.add(DropdownMenuItem(
      child: Text("BB", style: TextStyle(color: Colors.white, fontSize: 20)),
      value: 3,
    ));
    courseScores.add(DropdownMenuItem(
      child: Text("CB", style: TextStyle(color: Colors.white, fontSize: 20)),
      value: 2.5,
    ));
    courseScores.add(DropdownMenuItem(
      child: Text("CC", style: TextStyle(color: Colors.white, fontSize: 20)),
      value: 2,
    ));
    courseScores.add(DropdownMenuItem(
      child: Text("DC", style: TextStyle(color: Colors.white, fontSize: 20)),
      value: 1.5,
    ));
    courseScores.add(DropdownMenuItem(
      child: Text("DD", style: TextStyle(color: Colors.white, fontSize: 20)),
      value: 1,
    ));
    courseScores.add(DropdownMenuItem(
      child: Text("FD", style: TextStyle(color: Colors.white, fontSize: 20)),
      value: 0.5,
    ));
    courseScores.add(DropdownMenuItem(
      child: Text("FF", style: TextStyle(color: Colors.white, fontSize: 20)),
      value: 0,
    ));
    return courseScores;
  }

  Widget _createListElements(BuildContext context, int index) {
    counter++;
    print(counter);
    return Dismissible(
      key: Key(counter.toString()),
      onDismissed: (dismiss) {
        setState(() {
          allCourses.removeAt(index);
          print(allCourses.length.toString() + "s");
          calculateAvg();
        });
      },
      direction: DismissDirection.endToStart,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: ListTile(
            leading: CircleAvatar(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                child: Icon(Icons.school_outlined)),
            title: Text(allCourses[index].name),
            subtitle: Text(allCourses[index].credit.toString() + " ECTS")),
      ),
    );
  }

  void calculateAvg() {
    double allScore = 0;
    double allCredit = 0;

    for (var currentCourse in allCourses) {
      var credit = currentCourse.credit;
      var score = currentCourse.score;

      allScore = allScore + (score * credit);
      allCredit = allCredit + credit;
    }
    average = allScore / allCredit;
  }
}

class Course {
  String name;
  double score;
  int credit;

  Course(
    this.name,
    this.score,
    this.credit,
  );

  get getName => this.name;

  set setName(name) => this.name = name;

  get getScore => this.score;

  set setScore(score) => this.score = score;

  get getCredit => this.credit;

  set setCredit(credit) => this.credit = credit;
}
