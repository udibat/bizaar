import { Component, PropTypes } from 'react';
import r, { div } from 'r-dom';
import { t } from '../../../utils/i18n';
import classNames from 'classnames';

import { className as classNameProp } from '../../../utils/PropTypes';
import css from './SignupDropdown.css';

const HOVER_TIMEOUT = 250;

function SignupLinks(props) {
  return div({
    className: className,
    href: this.props.href
  });
}


class SignupDropdown extends Component {
  state = {
    isOpen: false
  }

  handleMouseOver = () => this.setState({isOpen: true})
  handleMouseLeave = () => this.setState({isOpen: false})

  render () {
    const openClass = this.state.isOpen ? css.open : '';

    const signUpLinksTemplate = this.props.links.map(link => {
      return r.a({href: link.href, className: classNames(css.item)}, [
        r.div({
          className: css.imageBlock,
          dangerouslySetInnerHTML: { __html: link.image },
        }),
        r.span(link.text),
        r.span(link.subtext),
      ])
    })

    const signUp = div({
      className: classNames(css.text),
      onMouseOver: this.handleMouseOver,
      onMouseLeave: this.handleMouseLeave,
    }, ['Sign up']);

    const links = div({
      className: classNames(css.links),
      onMouseOver: this.handleMouseOver,
      onMouseLeave: this.handleMouseLeave,
    }, [signUpLinksTemplate]);


    let resultTemplate = [signUp, links];

    return div({
      className: classNames('SignupDropdown', this.props.className, css.signupDropdown, openClass),
    }, resultTemplate)
  }
}

export default SignupDropdown;