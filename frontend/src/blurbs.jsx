import React from "react";
import ReactDOM from "react-dom/client";
const bl_root = ReactDOM.createRoot(document.getElementById('blurb-list-root'));
//const search_root = ReactDOM.createRoot(document.getElementById('search-root'));

class Blurb extends React.Component {
  render() {
    
    return <div className="blurb" id={this.props.key}>
             <p> {this.props.date} </p>
             <p> {this.props.content} </p>
           </div>;
  }
}

class App extends React.Component {
  render() {
    const blurbs = this.props.blurbs.map( (b,i) => {
      return <li key={i.toString()}> {b} </li>;
    });
    return <div className="app">
      <form action="add_blurb()">
        <input name="blurb_content" type="text" autoFocus/>
        <input type="hidden" name="username" value="USERNAME"/>
        <input type="submit" value="Write blurb" formMethod="post"/>
      </form>

        <ul> { blurbs } </ul>;
    </div>
  }
}

function add_blurb() {
  //todo, called in App component 
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

document.load_blurbs = function load_blurbs(json_blurbs) {
  //TODO, render blurbs directly from server. Maybe this is a bad idea.
}


// filter blurbs in blurbs based on text input
// TODO: add blurb
// TODO: filter blurbs

