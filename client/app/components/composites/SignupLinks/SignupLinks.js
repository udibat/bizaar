import { PropTypes } from 'react';
import r, { div } from 'r-dom';
import { t } from '../../../utils/i18n';
import classNames from 'classnames';

import { className as classNameProp } from '../../../utils/PropTypes';
import Link from '../../elements/Link/Link';
import css from './SignupLinks.css';

export default function SignupLinks({ loginUrl, signupUrl, customColor, className }) {
  return div({
    className: classNames('SignupLinks', css.links, className),
  }, [
    r(Link, {
      className: css.link,
      href: signupUrl,
      customColor,
    }, 'Signup as Student'),
    r(Link, {
      className: css.link,
      href: signupUrl,
      customColor,
    }, 'Signup as Instructor'),
  ]);
}

SignupLinks.propTypes = {
  loginUrl: PropTypes.string.isRequired,
  signupUrl: PropTypes.string.isRequired,
  customColor: PropTypes.string,
  className: classNameProp,
};
