import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: const CalculatorBody(),
    );
  }
}

class CalculatorBody extends StatefulWidget {
  const CalculatorBody({Key? key}) : super(key: key);

  @override
  State<CalculatorBody> createState() => _CalculatorBodyState();
}

class _CalculatorBodyState extends State<CalculatorBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle:
        SystemUiOverlayStyle(statusBarColor: Colors.white.withOpacity(0)),
        backgroundColor: Theme.of(context).primaryColorDark,
      ),
      body: const Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  const Calculator({Key? key}) : super(key: key);

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  var field = TextEditingController();
  String text = '';
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: field,
          style: const TextStyle(fontSize: 60),
          readOnly: true,
          showCursor: false,
          textAlign: TextAlign.right,
          decoration: const InputDecoration(
              fillColor: Colors.black,
              filled: true,
              contentPadding: EdgeInsets.all(50)),
        ),
        Expanded(
          child: Container(
            color: Theme.of(context).primaryColor,
            child: GridView.count(
              crossAxisCount: 4,
              mainAxisSpacing: 5,
              crossAxisSpacing: 50,
              childAspectRatio: 0.65,
              children: [
                TextButton(
                  onPressed: () => setState(() {
                    field.text = '';
                  }),
                  child: const Text(
                    "C",
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() {
                    field.text += '(';
                  }),
                  child: const Text(
                    "(",
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() {
                    field.text += ')';
                  }),
                  child: const Text(
                    ")",
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (field.text.isNotEmpty) {
                      setState(() {
                        field.text =
                            field.text.substring(0, field.text.length - 1);
                      });
                    }
                  },
                  icon: const Icon(Icons.backspace_outlined),
                ),
                TextButton(
                  onPressed: () => setState(() {
                    field.text += '7';
                  }),
                  child: const Text(
                    "7",
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() {
                    field.text += '8';
                  }),
                  child: const Text(
                    "8",
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() {
                    field.text += '9';
                  }),
                  child: const Text(
                    "9",
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                ),
                buildMathOperator(context,
                    fieldText: "\u00F7", icon: FontAwesomeIcons.divide),
                TextButton(
                  onPressed: () => setState(() {
                    field.text += '4';
                  }),
                  child: const Text(
                    "4",
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() {
                    field.text += '6';
                  }),
                  child: const Text(
                    "5",
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() {
                    field.text += '6';
                  }),
                  child: const Text(
                    "6",
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                ),
                buildMathOperator(context,
                    fieldText: "\u00d7", icon: FontAwesomeIcons.xmark),
                TextButton(
                  onPressed: () => setState(() {
                    field.text += '1';
                  }),
                  child: const Text(
                    "1",
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() {
                    field.text += '2';
                  }),
                  child: const Text(
                    "2",
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() {
                    field.text += '3';
                  }),
                  child: const Text(
                    "3",
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                ),
                buildMathOperator(context,
                    fieldText: "+", icon: FontAwesomeIcons.plus),
                buildEqualOperator(context, icon: FontAwesomeIcons.equals),
                TextButton(
                  onPressed: () => setState(() {
                    field.text += '0';
                  }),
                  child: const Text(
                    "0",
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() {
                    field.text += '.';
                  }),
                  child: const Text(
                    ".",
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                ),
                buildMathOperator(context,
                    fieldText: "-", icon: FontAwesomeIcons.minus),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget buildEqualOperator(BuildContext context, {required IconData icon}) {
    return InkWell(
      onTap: () {
        String expression='';
        for(int i=0;i<field.text.length;i++){
          if(field.text[i]=='×'){
            expression+='*';
          }
          else if(field.text[i]=='÷'){
            expression+='/';
          }
          else{
            expression+=field.text[i];
          }
        }
        try {
          Parser p = Parser();
          Expression exp = p.parse(expression);
          ContextModel cm = ContextModel();
          double eval = exp.evaluate(EvaluationType.REAL, cm);
          setState(() {
            field.text = '$eval';
          });
        } catch (e) {
          setState(() {
            field.text = 'ERR';
          });
        }
      },
      child: Container(
        alignment: Alignment.center,
        decoration:
        const BoxDecoration(color: Colors.blueGrey, shape: BoxShape.circle),
        child: FaIcon(icon),
      ),
    );
  }

  Widget buildMathOperator(BuildContext context,
      {required String fieldText, required IconData icon}) {
    return InkWell(
      onTap: () => setState(() {
        field.text += fieldText;
      }),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Theme.of(context).canvasColor, shape: BoxShape.circle),
        child: FaIcon(icon),
      ),
    );
  }
}
