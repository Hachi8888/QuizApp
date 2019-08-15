//
//  ViewController.swift
//  QuizApp
//
//  Created by VERTEX22 on 2019/08/13.
//  Copyright © 2019 N-project. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // クイズの番号を管理する番号
    var quizNum: Int = 0
    
    // 回答した問題の正誤を記録する
    var result: [String] = []
    

    // クイズを表示するテキストビュー
    @IBOutlet weak var quizTextView: UITextView!
    
    // 問題文(辞書のキー:何問目か、問題文、正解の問題番号、回答ボタンの数)
    let Quiz:[[String: Any]] = [
        ["QuizTitle": "1", "QuizText": "日本の世界遺産『富士山－信仰の対象と芸術の源泉』は、2013年に（ ）として世界遺産登録されました。\n\n1. 文化遺産\n2. 自然遺産\n3. 山岳遺産\n4. 伝統遺産", "correctNum": 1, "Layout": 4],
     ["QuizTitlem": 2, "QuizText": "イタリア共和国の世界遺産『フィレンツェの歴史地区』のあるフィレンツェを中心に、17世紀に栄えた芸術運動は何でしょうか。\n\n1. シュルレアリスム \n2. アバンギャルド \n3. ルネサンス", "correctNum": 3,"Layout": 3],
     ["QuizTitle": 3, "QuizText": "2016年のオリンピック開催地であるリオ・デ・ジャネイロで、ブラジル独立100周年を記念して作られたキリスト像が立つ場所として、正しいものはどれか。\n\n1. コパカバーナの山 \n2. コルコバードの丘", "correctNum": 2,"Layout": 2]
    ]
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // 問題文を表示する
        showQuiz()
        wrongAlert()
    }
    
    
    
    // 問題文を表示させる関数
    func showQuiz() {
        /* quizNumをもとに、Quizの辞書から現在の問題を特定する。
         特定したCurrentQuizは、現在のクイズ番号の問題内容が配列で入っている。*/
        var CurrentQuiz = Quiz[quizNum]
        
         // 【問題のタイトルを表示】
        if let title = CurrentQuiz["Quiztitle"] {
            self.navigationItem.title = title as? String
        }
        //【問題文を表示】CurrentQuizから、"QuizText"をキーに取り出し表示する。
        quizTextView.text = CurrentQuiz["QuizText"]! as? String
    }


    // 正解のアラートを表示する関数
    func correctAlert() {
        // アラートの作成
        let alert = UIAlertController(title: "正解", message: "次に進みます", preferredStyle: .alert)
        // アラートのアクション(ボタンの定義)
        let OK = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        // 作成したalertにOKボタンを追加
        alert.addAction(OK)
        // アラートを表示する
        present(alert, animated: true, completion: nil)

       // 問題を進める
        quizNum += 1
        // 結果を記録する
        result.append("◯")

        // 最後の問題を回答していれば、結果の画面に遷移する。最後の問題でなければ次の問題へ進む。
        if self.quizNum >= self.Quiz.count {
            // 最後の問題なので結果画面へ遷移する
            self.performSegue(withIdentifier: "showResult", sender: <#T##Any?#>)
        } else {
            // 次の問題を表示する
            self.showQuiz()
        }
    }

    // 不正解のアラートを表示させる関数
    func wrongAlert() {
        // アラートの作成
        let alert = UIAlertController(title: "不正解", message: "次の問題に進みますか?", preferredStyle: .alert)

        // アラートの中の進むボタンを定義 (styleは .defaultで設定すること)
        let nextQ = UIAlertAction(title: "進む", style: .default
            , handler: {(action: UIAlertAction!) in
         // 進むを押したときの処理
            // 問題番号を進める
            self.quizNum += 1
            // 結果を記録する
            self.result.append("☓")

            // 最後の問題を回答していれば、結果の画面に遷移する。最後の問題でなければ次の問題へ進む。
                if self.quizNum >= self.Quiz.count {
                    // 最後の問題なので結果画面へ遷移する
                self.performSegue(withIdentifier: "showResult", sender: <#T##Any?#>)
                } else {
                    // 次の問題を表示する
                    self.showQuiz()
                }
        })

        // やり直しボタンを定義(押しても何も処理しない)
        let backQ = UIAlertAction(title: "やり直す", style: .default
            , handler: nil)

        // 作成したalertに進むボタン、やり直しボタンを追加
        alert.addAction(nextQ)
        alert.addAction(backQ)

        // アラートを表示する
        present(alert, animated: true, completion: nil)
    }
    
    
    // 正誤判定:1~4のボタンを紐付け(タグ番号をそれぞれ0〜3で付与)
    @IBAction func selectAnswer(_ sender: UIButton) {
        
        // quizNumをもとに、Quizの辞書から現在の問題を特定する
        var CurrentQuiz = Quiz[quizNum]
        
        // 回答の正誤を判定
        let num = sender.tag
        if num + 1 == CurrentQuiz["correctNum"] as! Int {
            // 正解
            correctAlert()
        } else {
           // 不正解
            wrongAlert()
        }
    }
}

