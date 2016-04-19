//
//  ViewController.swift
//  Calcumalator
//
//  Created by Mark on 4/03/2016.
//  Copyright © 2016 marko5049. All rights reserved.
//

import UIKit
import MathParser

extension String {
    func contains(find: String) -> Bool{
        return self.rangeOfString(find) != nil
    }
    
    func replace(rin: String, rout: String) -> String
    {
        return self.stringByReplacingOccurrencesOfString(rin, withString: rout);
    }
    
    var asFloat: Float {
        return (self as NSString).floatValue;
    }
    
    var asInteger: Int {
        return (self as NSString).integerValue;
    }
}

extension Float {
    var asString : String {
        return NSString(format: "%.3f", self) as String;
    }
}

extension Character {
    var isNumber : Bool {
        return self == "0" || self == "1" || self == "2" || self == "3" || self == "4" || self == "5" || self == "6" || self == "7" || self == "8" || self == "9";
    }
}

class Colors {
    let colorTop = UIColor(red: 51.0/255.0, green: 184.0/255.0, blue: 204.0/255.0, alpha: 1.0).CGColor;
    let colorBottom = UIColor(red: 184.0/255.0, green: 194.0/255.0, blue: 204.0/255.0, alpha: 1.0).CGColor;
    
    let gl: CAGradientLayer;
    
    init() {
        gl = CAGradientLayer();
        gl.colors = [ colorTop, colorBottom];
        gl.locations = [ 0.0, 1.0];
    }
}

class ViewController: UIViewController {
    
    @IBOutlet var ViewOne: UIView!
    @IBOutlet weak var Zero: UIButton!
    @IBOutlet weak var One: UIButton!
    @IBOutlet weak var Two: UIButton!
    @IBOutlet weak var Three: UIButton!
    @IBOutlet weak var Four: UIButton!
    @IBOutlet weak var Five: UIButton!
    @IBOutlet weak var Six: UIButton!
    @IBOutlet weak var Seven: UIButton!
    @IBOutlet weak var Eight: UIButton!
    @IBOutlet weak var Nine: UIButton!
    @IBOutlet weak var Decimal: UIButton!
    @IBOutlet weak var Plus: UIButton!
    @IBOutlet weak var Minus: UIButton!
    @IBOutlet weak var Times: UIButton!
    @IBOutlet weak var Divide: UIButton!
    @IBOutlet weak var Clear: UIButton!
    @IBOutlet weak var Backspace: UIButton!
    @IBOutlet weak var Equals: UIButton!
    @IBOutlet weak var Shift: UIButton!
    @IBOutlet weak var AnswerLabel: UILabel!
    @IBOutlet weak var EquationLabel: UILabel!
    
    var shifted: Int = 1;
    var equation: String = "";
    var writeSuperscipt: Bool = false;
    let colors = Colors();
    
    func refreshColors()
    {
        view.backgroundColor = UIColor.clearColor()
        let backgroundLayer = colors.gl
        backgroundLayer.frame = view.frame
        view.layer.insertSublayer(backgroundLayer, atIndex: 0)
    }
    
    func computeValues()
    {
        let formattedEquation: String = equation.replace("⁻", rout: "-").replace("^", rout: "**");
        
        do
        {
            self.EquationLabel.text? = equation + " =  ";
            let _ = OperatorSet.init(interpretsPercentSignAsModulo: false);
            
            let exp = try Expression(string: formattedEquation);
            var eval: Evaluator = Evaluator();
            eval.angleMeasurementMode = .Degrees;
            let text = try eval.evaluate(exp);
            
            let formatter = NSNumberFormatter();
            formatter.minimumFractionDigits = 0;
            formatter.maximumFractionDigits = 8;
            self.equation = formatter.stringFromNumber(text)!;
            self.AnswerLabel.text? = equation;
        }
        catch _
        {
            AnswerLabel.text? = "Syntax Error";
        }
    }
    
    func onLeftSwipe(sender: UISwipeGestureRecognizer)
    {
        UIView.setAnimationsEnabled(false);
        if(shifted == 1)
        {
            secondaryText();
            secondarySize();
            shifted = 2;
        }
        else if(shifted == 2)
        {
            tertiaryText();
            secondarySize();
            shifted = 3;
        }
        else if(shifted == 3)
        {
            quaternaryText();
            secondarySize();
            shifted = 4;
        }
        else if(shifted == 4)
        {
            primaryText();
            primarySize();
            shifted = 1;
        }
        UIView.setAnimationsEnabled(true);
        update();
    }
    
    func onRightSwipe(sender: UISwipeGestureRecognizer)
    {
        UIView.setAnimationsEnabled(false);
        if(shifted == 4) {
            tertiaryText();
            secondarySize();
            shifted = 3;
        }
        else if(shifted == 3)
        {
            secondaryText();
            secondarySize();
            shifted = 2;
        }
        else if(shifted == 2)
        {
            primaryText();
            primarySize();
            shifted = 1;
        }
        else if(shifted == 1)
        {
            quaternaryText();
            secondarySize();
            shifted = 4;
        }
        UIView.setAnimationsEnabled(true);
        update();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        //refreshColors();
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("onLeftSwipe:"));
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("onRightSwipe:"));
        
        leftSwipe.direction = .Left;
        rightSwipe.direction = .Right;
        
        view.addGestureRecognizer(leftSwipe);
        view.addGestureRecognizer(rightSwipe);
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "rotated", name: UIDeviceOrientationDidChangeNotification, object: nil);
        
        rotated();
    }
    
    func rotated()
    {
        //refreshColors();
        
        var scale: CGFloat = 1.0;
        let frame: CGRect = self.Shift.frame;
        
        if(frame.width <= frame.height)
        {
            scale = frame.width / 92.0;
        }
        else
        {
            scale = frame.height / 92.0;
        }
        
        let font72 = UIFont(name: "System-Light", size: 72.0 * scale);
        let font64 = UIFont(name: "System-Light", size: 64.0 * scale);
        let font48 = UIFont(name: "System-Light", size: 48.0 * scale);
        
        self.Zero.titleLabel?.font = font72;
        self.One.titleLabel?.font = font72;
        self.Two.titleLabel?.font = font72;
        self.Three.titleLabel?.font = font72;
        self.Four.titleLabel?.font = font72;
        self.Five.titleLabel?.font = font72;
        self.Six.titleLabel?.font = font72;
        self.Seven.titleLabel?.font = font72;
        self.Eight.titleLabel?.font = font72;
        self.Nine.titleLabel?.font = font72;
        
        self.Plus.titleLabel?.font = font64;
        self.Minus.titleLabel?.font = font64;
        self.Times.titleLabel?.font = font64;
        self.Divide.titleLabel?.font = font64;
        self.Decimal.titleLabel?.font = font64;
        self.Equals.titleLabel?.font = font64;
        
        self.Clear.titleLabel?.font = font48;
        self.Shift.titleLabel?.font = font48;
        self.Backspace.titleLabel?.font = font48;
    }
    
    func primarySize()
    {
        rotated();
    }
    
    func secondarySize()
    {
        var scale: CGFloat = 1.0;
        let frame: CGRect = self.Shift.frame;
        
        if(frame.width <= frame.height)
        {
            scale = frame.width / 92.0;
        }
        else
        {
            scale = frame.height / 92.0;
        }
        
        let font40 = UIFont(name: "System-Light", size: 40.0 * scale);
        
        self.Zero.titleLabel?.font = font40;
        self.One.titleLabel?.font = font40;
        self.Two.titleLabel?.font = font40;
        self.Three.titleLabel?.font = font40;
        self.Four.titleLabel?.font = font40;
        self.Five.titleLabel?.font = font40;
        self.Six.titleLabel?.font = font40;
        self.Seven.titleLabel?.font = font40;
        self.Eight.titleLabel?.font = font40;
        self.Nine.titleLabel?.font = font40;
    }
    
    func primaryText()
    {
        Zero.setTitle("0", forState: UIControlState.Normal);
        One.setTitle("1", forState: UIControlState.Normal);
        Two.setTitle("2", forState: UIControlState.Normal);
        Three.setTitle("3", forState: UIControlState.Normal);
        Four.setTitle("4", forState: UIControlState.Normal);
        Five.setTitle("5", forState: UIControlState.Normal);
        Six.setTitle("6", forState: UIControlState.Normal);
        Seven.setTitle("7", forState: UIControlState.Normal);
        Eight.setTitle("8", forState: UIControlState.Normal);
        Nine.setTitle("9", forState: UIControlState.Normal);
    }
    
    func secondaryText()
    {
        Zero.setTitle("√", forState: UIControlState.Normal);
        One.setTitle("Sin", forState: UIControlState.Normal);
        Two.setTitle("Cos", forState: UIControlState.Normal);
        Three.setTitle("Tan", forState: UIControlState.Normal);
        Four.setTitle("Sin⁻¹", forState: UIControlState.Normal);
        Five.setTitle("Cos⁻¹", forState: UIControlState.Normal);
        Six.setTitle("Tan⁻¹", forState: UIControlState.Normal);
        Seven.setTitle("Log₁₀", forState: UIControlState.Normal);
        Eight.setTitle("Exp", forState: UIControlState.Normal);
        Nine.setTitle("Log₂", forState: UIControlState.Normal);
    }
    
    func tertiaryText()
    {
        Zero.setTitle("∛", forState: UIControlState.Normal);
        One.setTitle("Ceil", forState: UIControlState.Normal);
        Two.setTitle("Floor", forState: UIControlState.Normal);
        Three.setTitle("Deg", forState: UIControlState.Normal);
        Four.setTitle("Fac", forState: UIControlState.Normal);
        Five.setTitle("Fac2", forState: UIControlState.Normal);
        Six.setTitle("Rad", forState: UIControlState.Normal);
        Seven.setTitle("π", forState: UIControlState.Normal);
        Eight.setTitle("τ", forState: UIControlState.Normal);
        Nine.setTitle("e", forState: UIControlState.Normal);
    }
    
    func quaternaryText()
    {
        Zero.setTitle("ln", forState: UIControlState.Normal);
        One.setTitle("<=", forState: UIControlState.Normal);
        Two.setTitle(">=", forState: UIControlState.Normal);
        Three.setTitle("⁻", forState: UIControlState.Normal);
        Four.setTitle("x²", forState: UIControlState.Normal);
        Five.setTitle("x³", forState: UIControlState.Normal);
        Six.setTitle("xⁿ", forState: UIControlState.Normal);
        Seven.setTitle("<", forState: UIControlState.Normal);
        Eight.setTitle(">", forState: UIControlState.Normal);
        Nine.setTitle("ϕ", forState: UIControlState.Normal);
    }
    
    @IBAction func shift_click(sender: AnyObject)
    {
        self.equation += "(";
        update();
    }
    
    func update()
    {
        if(shifted == 4 && writeSuperscipt)
        {
            Six.backgroundColor = UIColor.lightGrayColor();
        }
        else
        {
            Six.backgroundColor = UIColor.whiteColor();
        }
        
        AnswerLabel.text? = equation;
    }
    
    /* SHIFTED FUNCTIONS */
    
    @IBAction func zero_click(sender: AnyObject) {
        if(shifted == 1)
        {
            if(writeSuperscipt)
            {
                equation += "⁰";
            }
            else
            {
                equation += "0";
            }
        }
        else if(shifted == 2)
        {
            equation += "√(";
        }
        else if(shifted == 3)
        {
            equation += "∛(";
        }
        else
        {
            equation += "ln(";
        }
        update();
    }
    @IBAction func one_click(sender: AnyObject) {
        if(shifted == 1)
        {
            if(writeSuperscipt)
            {
                equation += "¹";
            }
            else
            {
                equation += "1";
            }
        }
        else if(shifted == 2)
        {
            equation += "sin(";
        }
        else if(shifted == 3)
        {
            equation += "ceil(";
        }
        else
        {
            equation += "<=";
        }
        update();
    }
    @IBAction func two_click(sender: AnyObject) {
        if(shifted == 1)
        {
            if(writeSuperscipt)
            {
                equation += "²";
            }
            else
            {
                equation += "2";
            }
        }
        else if(shifted == 2)
        {
            equation += "cos(";
        }
        else if(shifted == 3)
        {
            equation += "floor(";
        }
        else
        {
            equation += ">=";
        }
        update();
    }
    @IBAction func three_click(sender: AnyObject) {
        if(shifted == 1)
        {
            if(writeSuperscipt)
            {
                equation += "³";
            }
            else
            {
                equation += "3";
            }
        }
        else if(shifted == 2)
        {
            equation += "tan(";
        }
        else if(shifted == 3)
        {
            equation += "rtod(";
        }
        else
        {
            equation += "⁻";
        }
        update();
    }
    @IBAction func four_click(sender: AnyObject) {
        if(shifted == 1)
        {
            if(writeSuperscipt)
            {
                equation += "⁴";
            }
            else
            {
                equation += "4";
            }
        }
        else if(shifted == 2)
        {
            equation += "asin(";
        }
        else if(shifted == 3)
        {
            equation += "!";
        }
        else
        {
            equation += "²";
        }
        update();
    }
    @IBAction func five_click(sender: AnyObject) {
        if(shifted == 1)
        {
            if(writeSuperscipt)
            {
                equation += "⁵";
            }
            else
            {
                equation += "5";
            }
        }
        else if(shifted == 2)
        {
            equation += "acos(";
        }
        else if(shifted == 3)
        {
            equation += "!!";
        }
        else
        {
            equation += "³";
        }
        update();
    }
    @IBAction func six_click(sender: AnyObject) {
        if(shifted == 1)
        {
            if(writeSuperscipt)
            {
                equation += "⁶";
            }
            else
            {
                equation += "6";
            }
        }
        else if(shifted == 2)
        {
            equation += "atan(";
        }
        else if(shifted == 3)
        {
            equation += "dtor(";
        }
        else
        {
            writeSuperscipt = !writeSuperscipt;
        }
        update();
    }
    @IBAction func seven_click(sender: AnyObject) {
        if(shifted == 1)
        {
            if(writeSuperscipt)
            {
                equation += "⁷";
            }
            else
            {
                equation += "7";
            }
        }
        else if(shifted == 2)
        {
            equation += "log(";
        }
        else if(shifted == 3)
        {
            equation += "π";
        }
        else
        {
            equation += "<";
        }
        update();
    }
    @IBAction func eight_click(sender: AnyObject) {
        if(shifted == 1)
        {
            if(writeSuperscipt)
            {
                equation += "⁸";
            }
            else
            {
                equation += "8";
            }
        }
        else if(shifted == 2)
        {
            equation += "exp(";
        }
        else if(shifted == 3)
        {
            equation += "τ";
        }
        else
        {
            equation += ">";
        }
        update();
    }
    @IBAction func nine_click(sender: AnyObject) {
        if(shifted == 1)
        {
            if(writeSuperscipt)
            {
                equation += "⁹";
            }
            else
            {
                equation += "9";
            }
        }
        else if(shifted == 2)
        {
            equation += "log2(";
        }
        else if(shifted == 3)
        {
            equation += "e";
        }
        else
        {
            equation += "ϕ";
        }
        update();
    }
    
    /* NON-SHIFTED FUNCTIONS */
    
    @IBAction func decimal_click(sender: AnyObject) {
        if(equation.characters.isEmpty)
        {
            equation += "0.";
        }
        else if(equation.characters.last!.isNumber)
        {
            equation += ".";
        }
        else if(equation.characters.last! != ".")
        {
            equation += "0.";
        }
        update();
    }
    @IBAction func plus_click(sender: AnyObject) {
        equation += "+";
        update();
    }
    @IBAction func minus_click(sender: AnyObject) {
        equation += "-";
        update();
    }
    @IBAction func time_click(sender: AnyObject) {
        equation += "×";
        update();
    }
    @IBAction func divide_click(sender: AnyObject) {
        equation += "÷";
        update();
    }
    @IBAction func clear_click(sender: AnyObject) {
        self.equation += ")";
        update();
    }
    @IBAction func backspace_click(sender: AnyObject) {
        //if(equation.characters.count >= 1)
        //{
        //    equation = equation.substringToIndex(equation.endIndex.predecessor());
        //}
        EquationLabel.text? = "";
        self.equation = "";
        update();
    }
    @IBAction func equals_click(sender: AnyObject) {
        computeValues();
    }
}

