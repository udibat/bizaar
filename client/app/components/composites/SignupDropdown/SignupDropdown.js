import { Component, PropTypes } from 'react';
import r, { div } from 'r-dom';
import { t } from '../../../utils/i18n';
import classNames from 'classnames';

import { className as classNameProp } from '../../../utils/PropTypes';
import Link from '../../elements/Link/Link';
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
      return r.a({href: link.href}, [
        link.text,
        r.img({src: link.image})
      ])
    })

    const signUp = div({
      onMouseOver: this.handleMouseOver,
      onMouseLeave: this.handleMouseLeave,
    }, ['Sign Up']);

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

  // constructor(props, context) {
  //   super(props, context);

  //   this.handleMouseOver = this.handleMouseOver.bind(this);
  //   this.handleMouseLeave = this.handleMouseLeave.bind(this);
  //   this.handleClick = this.handleClick.bind(this);
  //   this.handleBlur = this.handleBlur.bind(this);

  //   this.state = {
  //     isOpen: false,
  //     isMounted: false,
  //   };

  //   this.mouseOverTimeout = null;
  //   this.mouseLeaveTimeout = null;
  // }

  // componentDidMount() {
  //   this.setState({ isMounted: true });// eslint-disable-line react/no-set-state
  // }

  // componentWillUnmount() {
  //   window.clearTimeout(this.mouseLeaveTimeout);
  //   window.clearTimeout(this.mouseOverTimeout);
  // }

  // handleMouseOver() {
  //   window.clearTimeout(this.mouseLeaveTimeout);
  //   window.clearTimeout(this.mouseOverTimeout);
  //   this.mouseOverTimeout = window.setTimeout(() => (
  //     this.setState({ isOpen: true }) // eslint-disable-line react/no-set-state
  //     ), HOVER_TIMEOUT);
  // }

  // handleMouseLeave() {
  //   window.clearTimeout(this.mouseOverTimeout);
  //   this.mouseLeaveTimeout = window.setTimeout(() => (
  //     this.setState({ isOpen: false }) // eslint-disable-line react/no-set-state
  //     ), HOVER_TIMEOUT);
  // }

  // handleClick() {
  //   this.setState({ isOpen: !this.state.isOpen });// eslint-disable-line react/no-set-state
  // }

  // handleBlur(event) {
  //   // FocusEvent is fired faster than the link elements native click handler
  //   // gets its own event. Therefore, we need to check the origin of this FocusEvent.
  //   if (this.state.isOpen && !this.signupDropdown.contains(event.relatedTarget)) {
  //     this.setState({ isOpen: false });// eslint-disable-line react/no-set-state
  //   }
  // }

  // render() {
  //   const openOnHoverClass = this.state.isMounted ? '' : css.openOnHover;
  //   const transitionDelayClass = this.state.isMounted ? '' : css.transitionDelay;
  //   const openClass = this.state.isOpen ? css.openDropdown : '';
  //   const notificationsClass = this.props.notificationCount > 0 ? css.hasNotifications : null;
  //   // const notificationBadgeInArray = this.props.notificationCount > 0 ?
  //   //   [r(NotificationBadge, { className: css.notificationBadge }, this.props.notificationCount)] :
  //   //   [];
  //   return div({
  //     onMouseOver: this.handleMouseOver,
  //     onMouseLeave: this.handleMouseLeave,
  //     onClick: this.handleClick,
  //     onBlur: this.handleBlur,
  //     tabIndex: 0,
  //     className: classNames('SignupDropdown', this.props.className, openOnHoverClass, openClass, css.signupDropdown, notificationsClass),
  //   }, [
  //     div({ className: css.avatarWithNotifications }, [
  //       r(Avatar, this.props.avatar),
  //     ].concat(notificationBadgeInArray)),
  //     r(SignupDropdown, {
  //       classNames: [css.avatarProfileDropdown, transitionDelayClass],
  //       customColor: this.props.customColor,
  //       actions: this.props.actions,
  //       isAdmin: this.props.isAdmin,
  //       notificationCount: this.props.notificationCount,
  //       translations: this.props.translations,
  //       signupDropdownRef: (c) => {
  //         this.signupDropdown = c;
  //       },
  //     }),
  //   ]);
  // }
}

// const { signupDropdownRef, ...passedThroughProps } = SignupDropdown.propTypes; // eslint-disable-line no-unused-vars
// SignupDropdown.propTypes = {
//   avatar: PropTypes.shape(Avatar.propTypes).isRequired,
//   notificationCount: PropTypes.number,
//   ...passedThroughProps,
//   className,
// };

export default SignupDropdown;