import React from "react";
import ReactDOM from "react-dom/client";
const bl_root = ReactDOM.createRoot(document.getElementById('blurb-list-root'));
//const search_root = ReactDOM.createRoot(document.getElementById('search-root'));

class Blurb extends React.Component {
  render() {
    return <div className="blurb">
             <p> {this.props.date} </p>
             <p> {this.props.content} </p>
           </div>;
  }
}

class App extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      newContent: "LOADING",
      blurbs: [<Blurb key="1" content="LOADING..."/>]
    }
    fetch('/blurbs', {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json;charset=utf-8'
      },
    }).then(res => res.json()).then((json) => {
      const blurbs = json.blurbs.map( blurb => {
        return <li key={blurb.blurb_id}> 
                 <Blurb date={blurb.date} content={blurb.content}/>
               </li>;
      });
      this.setState({
        newContent: "",
        blurbs: blurbs,
      });
    });

    this.handleNewBlurb = this.handleNewBlurb.bind(this);
    this.handleContentChange = this.handleContentChange.bind(this);
  }

  handleContentChange(e) {
    this.setState({newContent: e.target.value});
  }

  handleNewBlurb(e) {
    //TODO: implement
    fetch('/blurb', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json;charset=utf-8'
      },
      body: JSON.stringify({ blurb_content: this.state.newContent })
    }).then(res => res.json()).then((json) => {
      let blurb = <li key={json.blurb_id} >
                    <Blurb date={json.date} content={this.state.newContent}/>
                  </li>;
      this.setState({ 
        newContent: "",
        blurbs: [blurb].concat(this.state.blurbs),
      });
    });
    
    e.preventDefault();
  }

  render() {
    return <div className="app">
      <form onSubmit={this.handleNewBlurb}>
        <input name="blurb_content" type="text" value={this.state.newContent} onChange={this.handleContentChange} autoFocus autoComplete="off"/>
        <input type="hidden" name="username" value="TODO_USERNAME"/>
        <input type="submit" value="write new blurb"/>
      </form>

        <ul className="blurbList"> { this.state.blurbs } </ul>
    </div>
  }
}

//TODO: get these blurbs from backend as JSON
let blurbs = [];
blurbs.push(<Blurb date="11/25/2022" content="forks and spoons" />);
blurbs.push(<Blurb date="11/25/2022" content="poo emoji"/>);
blurbs.push(<Blurb date="11/25/2022" content="emos are goths that hate themselves"/>);
blurbs.push(<Blurb date="11/25/2022" content="they ate and ate and ate"/>);
blurbs.push(<Blurb date="11/25/2022" content="note to self: orcs not orks"/>);
blurbs.push(<Blurb date="11/25/2022" content="remember to sing loudly"/>);
let app = <App blurbs={blurbs} />;

bl_root.render(app);

